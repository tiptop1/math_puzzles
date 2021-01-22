import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configuration.dart';
import '../localizations.dart';
import '../model.dart';
import '../puzzle_generator.dart';
import 'color_scheme_extensions.dart';
import 'math_puzzle.dart' as math_puzzle;

// TODO: Change question if answer is presented - e.g. "Is result correct?".
// TODO: Buttons for score answer should have fixed width.
// TODO: Incomplete rendered question on Motorola One if device in landscape position.
class PuzzleRoute extends StatelessWidget {
  final Configuration _configuration;

  PuzzleRoute(this._configuration);

  @override
  Widget build(BuildContext context) {
    var parameterValues = _toValues(_configuration.parameters);
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
              create: (_) => PuzzleModel(PuzzleGeneratorManager()
                  .findNextEnabledGenerator(parameterValues)
                  .generate(parameterValues))),
          ChangeNotifierProvider<SessionModel>(create: (_) => SessionModel()),
        ],
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: FittedBox(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).puzzleQuestion,
                    // style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
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
                    child: AnswerButtonsWidget(
                        _configuration, puzzleModel, sessionModel),
                  ),
                );
              },
            ),
            Consumer<SessionModel>(builder: (context, sessionModel, child) {
              return Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: StatusBarWidget(_configuration, sessionModel),
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
  final Configuration _configuration;
  final PuzzleModel _puzzleModel;
  final SessionModel _sessionModel;

  AnswerButtonsWidget(
      this._configuration, this._puzzleModel, this._sessionModel);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_puzzleModel.puzzleAnswered) {
      widget = RaisedButton.icon(
        icon: Icon(Icons.question_answer),
        label: Text(
          AppLocalizations.of(context).showAnswerButton,
        ),
        color: Theme.of(context).colorScheme.answer,
        onPressed: _showAnswerCallback,
      );
    } else {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(flex: 10),
          RaisedButton.icon(
              icon: Icon(Icons.close),
              label: Text(AppLocalizations.of(context).incorrectAnswerButton),
              color: Theme.of(context).colorScheme.incorrectAnswer,
              onPressed: () =>
                  _incorrectAnswerCallback(context, _sessionModel)),
          Spacer(flex: 3),
          RaisedButton.icon(
              icon: Icon(Icons.check),
              label: Text(
                AppLocalizations.of(context).correctAnswerButton,
              ),
              color: Theme.of(context).colorScheme.correctAnswer,
              onPressed: () => _correctAnswerCallback(context, _sessionModel)),
          Spacer(flex: 10),
        ],
      );
    }
    return widget;
  }

  void _correctAnswerCallback(BuildContext context, SessionModel sessionModel) {
    _sessionModel.increaseCorrectAnswersCount();
    var parameterValues = _toValues(_configuration.parameters);
    _puzzleModel.puzzle = PuzzleGeneratorManager()
        .findNextEnabledGenerator(parameterValues)
        .generate(parameterValues);
    if (_sessionModel.correctAnswersCount +
            _sessionModel.incorrectAnswersCount >=
        _configuration.parameters[Configuration.paramPuzzlesCount].value) {
      Navigator.pushNamed(context, math_puzzle.Route.sessionSummary,
          arguments: sessionModel);
    }
  }

  void _incorrectAnswerCallback(
      BuildContext context, SessionModel sessionModel) {
    _sessionModel.increaseIncorrectAnswersCount();
    var parameterValues = _toValues(_configuration.parameters);
    _puzzleModel.puzzle = PuzzleGeneratorManager()
        .findNextEnabledGenerator(parameterValues)
        .generate(parameterValues);
    if (_sessionModel.correctAnswersCount +
            _sessionModel.incorrectAnswersCount >=
        _configuration.parameters[Configuration.paramPuzzlesCount].value) {
      Navigator.pushNamed(context, math_puzzle.Route.sessionSummary,
          arguments: sessionModel);
    }
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
    var answerTheme = Theme.of(context).textTheme.headline5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_model.puzzle.question} = ',
          style: answerTheme,
        ),
        Text(
          _model.puzzleAnswered ? '${_model.puzzle.answer}' : '?',
          style: answerTheme.apply(color: Theme.of(context).colorScheme.answer),
        ),
      ],
    );
  }
}

class StatusBarWidget extends StatelessWidget {
  static const statusSeparator = '|';

  final Configuration _configuration;
  final SessionModel _sessionModel;

  StatusBarWidget(this._configuration, this._sessionModel);

  @override
  Widget build(BuildContext context) {
    var puzzlesCount =
        _configuration.parameters[Configuration.paramPuzzlesCount].value;
    var correctAnswersCount = _sessionModel.correctAnswersCount;
    var incorrectAnswersCount = _sessionModel.incorrectAnswersCount;
    var textStyle = Theme.of(context).textTheme.headline6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Number of to do puzzles
        Text(
          '${puzzlesCount - correctAnswersCount - incorrectAnswersCount}$statusSeparator',
          style: textStyle,
        ),
        // Number or correct answers
        Text(
          '$correctAnswersCount',
          style: textStyle.apply(
              color: Theme.of(context).colorScheme.correctAnswer),
        ),
        Text(statusSeparator, style: textStyle),
        Text(
          '$incorrectAnswersCount',
          style: textStyle.apply(
              color: Theme.of(context).colorScheme.incorrectAnswer),
        ),
      ],
    );
  }
}

Map<String, dynamic> _toValues(Map<String, Parameter> parameters) {
  return parameters.map((name, parameter) => MapEntry(name, parameter.value));
}
