import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:math_puzzles/bloc/bloc_provider.dart';
import 'package:math_puzzles/bloc/math_puzzle_bloc.dart';

import 'bloc/settings_bloc.dart';
import 'data/config/configuration.dart';
import 'generated/l10n.dart';
import 'gui/math_puzzle_route.dart';
import 'gui/settings_route.dart';

class Route {
  static const String puzzle = '/';
  static const String settings = '/settings';
}

void main() {
  GetIt.I.registerSingletonAsync<Configuration>(
    () async => Configuration.load(),
    dispose: (conf) => conf.store(),
  );

  runApp(
    MaterialApp(
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
        Route.puzzle: (context) => BlocProvider<MathPuzzleBloc>(
              bloc: MathPuzzleBloc(),
              child: MathPuzzleRoute(),
            ),
        Route.settings: (context) => BlocProvider<SettingsBloc>(
              bloc: SettingsBloc(),
              child: SettingsRoute(),
            ),
      },
    ),
  );
}

class BlockProvider {}

Widget buildWidget() {
  return FutureBuilder(
    future: GetIt.I.allReady(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.hasData ? MathPuzzleRoute() : progressBarWidget();
    },
  );
}

Widget progressBarWidget() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
