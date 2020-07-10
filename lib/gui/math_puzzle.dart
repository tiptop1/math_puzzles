import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/model.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:math_puzzles/session.dart';

import 'package:math_puzzles/localizations.dart';
import 'package:provider/provider.dart';

class MathPuzzleWidget extends StatefulWidget {
  final Configuration _configuration;
  final Session _session;

  MathPuzzleWidget(this._configuration) : _session = Session();

  @override
  State<StatefulWidget> createState() {
    return _MathPuzzleState();
  }
}

class _MathPuzzleState extends State<MathPuzzleWidget> {
  static const String rootRoute = "/";
  static const String settingsRoute = "/settings";

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
          AppLocalizations.of(context).title,
      initialRoute: rootRoute,
      routes: {
        rootRoute: (context) =>
            PuzzleRoute(widget._configuration, widget._session),
        settingsRoute: (context) => SettingsRoute(),
      },
    );
  }
}

class PuzzleRoute extends StatelessWidget {
  final Configuration _configuration;
  final Session _session;

  PuzzleRoute(this._configuration, this._session);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math puzzles'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => Navigator.pushNamed(context, value),
            itemBuilder: (buildContext) {
              return [
                PopupMenuItem<String>(
                    value: _MathPuzzleState.settingsRoute,
                    child: Text('Settings')),
              ];
            },
          )
        ],
      ),
      body: ChangeNotifierProvider<PuzzleModel>(
        create: (context) => PuzzleModel(PuzzleGeneratorManager.instance()
            .findNextGenerator(_configuration.parameters)
            .generate(_configuration.parameters)),
        child: Column(
          children: [
            Consumer<PuzzleModel>(builder: (context, model, child) {
              return PuzzleWidget(model);
            }),
            Consumer<PuzzleModel>(
              builder: (context, model, child) {
                return AnswerButtonsWidget(model, _configuration, _session);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: Center(child: Text("Settings form not implemented yet!")));
  }
}

class AnswerButtonsWidget extends StatelessWidget {
  final PuzzleModel _model;
  final Configuration _configuration;
  final Session _session;

  AnswerButtonsWidget(this._model, this._configuration, this._session);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_model.puzzleAnswered) {
      widget = RaisedButton(
        child: Text(AppLocalizations.of(context).showAnswer),
        onPressed: _showAnswerCallback,
      );
    } else {
      widget = Row(
        children: [
          RaisedButton(
              child: Text(AppLocalizations.of(context).incorrect),
              onPressed: _incorrectAnswerCallback),
          RaisedButton(
              child: Text(AppLocalizations.of(context).correct),
              onPressed: _correctAnswerCallback),
        ],
      );
    }
    return widget;
  }

  void _correctAnswerCallback() {
    _session.increaseCorrectAnswersCount();
    _model.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(_configuration.parameters)
        .generate(_configuration.parameters);
  }

  void _incorrectAnswerCallback() {
    _session.increaseIncorrectAnswersCount();
    _model.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(_configuration.parameters)
        .generate(_configuration.parameters);
  }

  void _showAnswerCallback() {
    _model.puzzleAnswered = true;
  }
}

class PuzzleWidget extends StatelessWidget {
  final PuzzleModel _model;

  PuzzleWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return Text(
        '${_model.puzzle.question} = ${_model.puzzleAnswered ? _model.puzzle.answer : '?'}');
  }
}
