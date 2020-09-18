import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/gui/puzzle_route.dart';
import 'package:math_puzzles/gui/settings_route.dart';
import 'package:math_puzzles/localizations.dart';

class Route {
  static const String root = '/';
  static const String settings = '/settings';
}

class MathPuzzleWidget extends StatefulWidget {
  final Configuration _configuration;

  MathPuzzleWidget(this._configuration);

  @override
  _MathPuzzleState createState() => _MathPuzzleState();

}

class _MathPuzzleState extends State<MathPuzzleWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget._configuration.store();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).applicationTitle,
      initialRoute: Route.root,
      routes: {
        Route.root: (context) =>
            PuzzleRoute(widget._configuration),
        Route.settings: (context) => SettingsRoute(widget._configuration),
      },
    );
  }
}
