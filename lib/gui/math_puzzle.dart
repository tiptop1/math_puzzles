import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_puzzles/generated/l10n.dart';
import 'package:math_puzzles/gui/puzzle_route.dart';
import 'package:math_puzzles/gui/session_summary_route.dart';
import 'package:math_puzzles/gui/settings_route.dart';

import '../data/config/configuration.dart';

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
            child: ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text(AppLocalizations.of(context).newSessionMenu),
            ),
          ),
          PopupMenuItem<String>(
            value: Route.settings,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).settingsMenu),
            ),
          ),
        ];
      },
    )
  ];
}
