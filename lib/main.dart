import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/math_puzzle_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'data/config/configuration.dart';
import 'generated/l10n.dart';
import 'gui/math_puzzle_route.dart';
import 'gui/progress_indicator_widget.dart';
import 'gui/settings_route.dart';

class Route {
  static const String puzzle = '/';
  static const String settings = '/settings';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: dispose: (conf) async => await conf.store() - it seems that it doesn't work
  GetIt.I.registerSingletonAsync<Configuration>(
    () async => await Configuration.load(),
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
        Route.puzzle: (context) => buildMathPuzzleRoute(),
        Route.settings: (context) => buildSettingsRoute(),
      },
    ),
  );
}

Widget buildMathPuzzleRoute() {
  return FutureBuilder(
    future: GetIt.I.allReady(),
    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      return snapshot.hasData
          ? BlocProvider<MathPuzzleBloc>(
              bloc: MathPuzzleBloc(),
              child: MathPuzzleRoute(),
            )
          : ProgressIndicatorWidget();
    },
  );
}

Widget buildSettingsRoute() => BlocProvider<SettingsBloc>(
      bloc: SettingsBloc(),
      child: SettingsRoute(),
    );
