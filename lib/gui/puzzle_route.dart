import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configuration.dart';
import '../localizations.dart';
import '../model.dart';
import '../puzzle_generator.dart';
import 'math_puzzle.dart' as math_puzzle;

class PuzzleRoute extends StatelessWidget {
  final Configuration _configuration;

  PuzzleRoute(this._configuration);

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
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PuzzleModel>(
              create: (_) => PuzzleModel(PuzzleGeneratorManager.instance()
                  .findNextGenerator(parameterValues)
                  .generate(parameterValues))),
          ChangeNotifierProvider<SessionModel>(create: (_) => SessionModel()),
        ],
        child: Column(
          children: [
            Consumer<PuzzleModel>(builder: (context, puzzleModel, child) {
              return PuzzleWidget(puzzleModel);
            }),
            Consumer2<PuzzleModel, SessionModel>(
              builder: (context, puzzleModel, sessionModel, child) {
                return AnswerButtonsWidget(
                    puzzleModel, sessionModel, _configuration);
              },
            ),
            Consumer<SessionModel>(builder: (context, sessionModel, child) {
              return StatusBarWidget(sessionModel);
            })
          ],
        ),
      ),
    );
  }
}

class AnswerButtonsWidget extends StatelessWidget {
  final PuzzleModel _puzzleModel;
  final SessionModel _sessionModel;
  final Configuration _configuration;

  AnswerButtonsWidget(
      this._puzzleModel, this._sessionModel, this._configuration);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_puzzleModel.puzzleAnswered) {
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
    _sessionModel.increaseCorrectAnswersCount();
    var parameterValues = _toValues(_configuration.parameters);
    _puzzleModel.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(parameterValues)
        .generate(parameterValues);
  }

  void _incorrectAnswerCallback() {
    _sessionModel.increaseIncorrectAnswersCount();
    var parameterValues = _toValues(_configuration.parameters);
    _puzzleModel.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(parameterValues)
        .generate(parameterValues);
  }

  void _showAnswerCallback() {
    _puzzleModel.puzzleAnswered = true;
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

class StatusBarWidget extends StatelessWidget {
  final SessionModel _model;

  StatusBarWidget(this._model);

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      children: <Widget>[
        Text('Correct:'),
        Text(_model.correctAnswersCount.toString()),
        Text('Incorrect:'),
        Text(_model.incorrectAnswersCount.toString()),
      ],
    );
  }
}

Map<String, dynamic> _toValues(Map<String, Parameter> parameters) {
  return parameters.map((name, parameter) => MapEntry(name, parameter.value));
}
