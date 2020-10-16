import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configuration.dart';
import '../localizations.dart';
import '../model.dart';
import '../puzzle_generator.dart';
import 'math_puzzle.dart' as math_puzzle;

class PuzzleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parameterValues = _toValues(Configuration.of(context).parameters);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).applicationTitle),
        leading: null,
        automaticallyImplyLeading: false,
        actions: math_puzzle.createActions(context),
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
            Expanded(
              flex: 10,
              child: Center(
                  child: Text(AppLocalizations.of(context).puzzleQuestion)),
            ),
            Consumer<PuzzleModel>(builder: (context, puzzleModel, child) {
              return Expanded(
                flex: 70,
                child: Center(
                  child: PuzzleWidget(puzzleModel),
                ),
              );
            }),
            Consumer2<PuzzleModel, SessionModel>(
              builder: (context, puzzleModel, sessionModel, child) {
                return Expanded(
                  flex: 10,
                  child: Center(
                    child: AnswerButtonsWidget(puzzleModel, sessionModel),
                  ),
                );
              },
            ),
            Consumer<SessionModel>(builder: (context, sessionModel, child) {
              return Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: StatusBarWidget(sessionModel),
                ),
              );
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

  AnswerButtonsWidget(this._puzzleModel, this._sessionModel);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_puzzleModel.puzzleAnswered) {
      widget = RaisedButton(
        child: Text(AppLocalizations.of(context).showAnswerButton),
        onPressed: _showAnswerCallback,
      );
    } else {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
              child: Text(AppLocalizations.of(context).incorrectAnswerButton),
              onPressed: () =>
                  _incorrectAnswerCallback(context, _sessionModel)),
          RaisedButton(
              child: Text(AppLocalizations.of(context).correctAnswerButton),
              onPressed: () => _correctAnswerCallback(context, _sessionModel)),
        ],
      );
    }
    return widget;
  }

  void _correctAnswerCallback(BuildContext context, SessionModel sessionModel) {
    _sessionModel.increaseCorrectAnswersCount();
    var config = Configuration.of(context);
    var parameterValues = _toValues(config.parameters);
    _puzzleModel.puzzle = PuzzleGeneratorManager.instance()
        .findNextGenerator(parameterValues)
        .generate(parameterValues);
    if (_sessionModel.correctAnswersCount +
            _sessionModel.incorrectAnswersCount >=
        config.parameters[Configuration.paramPuzzlesCount].value) {
      Navigator.pushNamed(context, math_puzzle.Route.sessionSummary,
          arguments: sessionModel);
    }
  }

  void _incorrectAnswerCallback(
      BuildContext context, SessionModel sessionModel) {
    _sessionModel.increaseIncorrectAnswersCount();
    var parameterValues = _toValues(Configuration.of(context).parameters);
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
  static const statusSeparator = '/';

  final SessionModel _sessionModel;

  StatusBarWidget(this._sessionModel);

  @override
  Widget build(BuildContext context) {
    var puzzlesCount = Configuration.of(context)
        .parameters[Configuration.paramPuzzlesCount]
        .value;
    var correctAnswersCount = _sessionModel.correctAnswersCount;
    var incorrectAnswersCount = _sessionModel.incorrectAnswersCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text((puzzlesCount - correctAnswersCount - incorrectAnswersCount)
            .toString()),
        Text(statusSeparator),
        Text(correctAnswersCount.toString()),
        Text('/'),
        Text(incorrectAnswersCount.toString()),
      ],
    );
  }
}

Map<String, dynamic> _toValues(Map<String, Parameter> parameters) {
  return parameters.map((name, parameter) => MapEntry(name, parameter.value));
}
