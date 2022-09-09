import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'data/config/configuration.dart';
import 'generated/l10n.dart';
import 'gui/math_puzzle.dart';
import 'gui/puzzle_route.dart';
import 'gui/session_summary_route.dart';
import 'gui/settings_route.dart';

class Route {
  static const String puzzle = '/';
  static const String settings = '/settings';
  static const String sessionSummary = '/sessionSummary';
}

void main() {
  GetIt.I.registerSingletonAsync<Configuration>(
    () async => Configuration.load(),
    dispose: (conf) => conf.store(),
  );

  runApp(MaterialApp(
    localizationsDelegates: [
      AppLocalizationDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('pl'),
      Locale('de'),
    ],
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context).applicationTitle,
    initialRoute: Route.puzzle,
    routes: {
      Route.puzzle: (context) => PuzzleRoute(),
      Route.settings: (context) => SettingsRoute(),
      Route.sessionSummary: (context) => SessionSummaryRoute(),
    },
  ));
}

Widget buildWidget() {
  return FutureBuilder(
    future: GetIt.I.allReady(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.hasData ? MathPuzzleWidget() : progressBarWidget();
    },
  );
}

Widget progressBarWidget() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
