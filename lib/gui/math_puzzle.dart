import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_puzzles/gui/puzzle_route.dart';
import 'package:math_puzzles/gui/session_summary_route.dart';
import 'package:math_puzzles/gui/settings_route.dart';
import 'package:math_puzzles/localizations.dart';

import '../configuration.dart';

class Route {
  static const String puzzle = '/';
  static const String settings = '/settings';
  static const String sessionSummary = '/sessionSummary';
}

class MathPuzzleWidget extends StatefulWidget {
  final Configuration _configuration;

  MathPuzzleWidget(this._configuration);

  @override
  _MathPuzzleState createState() => _MathPuzzleState();
}

class _MathPuzzleState extends State<MathPuzzleWidget> {
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
      initialRoute: Route.puzzle,
      routes: {
        Route.puzzle: (context) => PuzzleRoute(widget._configuration),
        Route.settings: (context) => SettingsRoute(widget._configuration),
        Route.sessionSummary: (context) => SessionSummaryRoute(),
      },
    );
  }
}

List<Widget> createActions(BuildContext context) {
  return <Widget>[
    PopupMenuButton<String>(
      onSelected: (value) => Navigator.pushNamed(context, value),
      itemBuilder: (buildContext) {
        return [
          PopupMenuItem<String>(
              value: Route.puzzle,
              child: Text(AppLocalizations.of(context).newSessionMenu)),
          PopupMenuItem<String>(
              value: Route.settings,
              child: Text(AppLocalizations.of(context).settingsMenu)),
        ];
      },
    )
  ];
}
