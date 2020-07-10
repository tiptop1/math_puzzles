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
  static const String _action_value_route = 'ACTION_ROUTE';
  static const String _action_prefix_generator = 'GENERATOR:';

  _selectPopupMenuCallback(String actionValue) {
    if (actionValue == _action_value_route) {
      // TOOD: Implement settings windows appear
    } else if (actionValue?.startsWith(_action_prefix_generator) ?? false) {
      String generatorName =
          actionValue.substring(_action_prefix_generator.length);
      String generatorEnabledParam =
          '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
      widget._configuration.parameters[generatorEnabledParam] =
          !widget._configuration.parameters[generatorEnabledParam];
    }
  }

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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Math puzzles'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _selectPopupMenuCallback,
              itemBuilder: (buildContext) {
                return [
                  PopupMenuItem<String>(
                      value: _action_value_route, child: Text('Settings')),
                ];
              },
            )
          ],
        ),
        body: ChangeNotifierProvider<PuzzleModel>(
          create: (context) => PuzzleModel(PuzzleGeneratorManager.instance()
              .findNextGenerator(widget._configuration.parameters)
              .generate(widget._configuration.parameters)),
          child: Column(
            children: [
              Consumer<PuzzleModel>(builder: (context, model, child) {
                return PuzzleWidget(model);
              }),
              Consumer<PuzzleModel>(
                builder: (context, model, child) {
                  return AnswerButtonsWidget(
                      model, widget._configuration, widget._session);
                },
              ),
            ],
          ),
        ),
      ),
    );
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
