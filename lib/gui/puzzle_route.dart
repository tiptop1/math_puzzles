import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configuration.dart';
import '../localizations.dart';
import '../model.dart';
import '../puzzle_generator.dart';
import '../session.dart';
import 'math_puzzle.dart' as math_puzzle;

class PuzzleRoute extends StatelessWidget {
  final Configuration _configuration;
  final Session _session;

  PuzzleRoute(this._configuration, this._session);

  @override
  Widget build(BuildContext context) {
    var parameterValues = _toValues(_configuration.parameters);
    return Scaffold(
      appBar: AppBar(
        title: Text('Math puzzles'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => Navigator.pushNamed(context, value),
            itemBuilder: (buildContext) {
              return [
                PopupMenuItem<String>(
                    value: math_puzzle.Route.settings, child: Text('Settings')),
              ];
            },
          )
        ],
      ),
      body: ChangeNotifierProvider<PuzzleModel>(
        create: (context) => PuzzleModel(PuzzleGeneratorManager.instance()
            .findNextGenerator(parameterValues)
            .generate(parameterValues)),
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
    var parameterValues = _toValues(_configuration.parameters);
    _model.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(parameterValues)
        .generate(parameterValues);
  }

  void _incorrectAnswerCallback() {
    _session.increaseIncorrectAnswersCount();
    var parameterValues = _toValues(_configuration.parameters);
    _model.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(parameterValues)
        .generate(parameterValues);
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

Map<String, dynamic> _toValues(Map<String, Parameter> parameters) {
  parameters.map((name, parameter) => MapEntry(name, parameter.value));
}
