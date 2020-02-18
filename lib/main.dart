import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:math_puzzles/session.dart';
import 'localizations.dart';

void main() => runApp(MathPuzzleWidget());

class MathPuzzleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MathPuzzleState();
}

class _MathPuzzleState extends State<MathPuzzleWidget> {
  static RandomPuzzleGenerator _puzzleGenerator = RandomPuzzleGenerator();

  Puzzle _puzzle =
      _puzzleGenerator.generatePuzzle(OperationType.integerAddition);
  bool _puzzleAnswered = false;
  Session _session = Session(10);

  _correctAnswerCallback() {
    setState(() {
      _puzzle = _puzzleGenerator.generatePuzzle(OperationType.integerAddition);
      _puzzleAnswered = false;
      _session.increaseCorrectAnswersCount();
    });
  }

  _incorrectAnswerCallback() {
    setState(() {
      _puzzle = _puzzleGenerator.generatePuzzle(OperationType.integerAddition);
      _puzzleAnswered = false;
      _session.increaseIncorrectAnswersCount();
    });
  }

  _showAnswerCallback() {
    setState(() {
      _puzzleAnswered = true;
    });
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
          appBar: AppBar(title: Text('Math puzzles')),
          body: Column(
            children: [
              Text(
                  '${_puzzle.question} = ${_puzzleAnswered ? _puzzle.answer : '?'}'),
              AnswerButtonsWidget(_puzzleAnswered, _showAnswerCallback,
                  _correctAnswerCallback, _incorrectAnswerCallback),
            ],
          )),
    );
  }
}

class AnswerButtonsWidget extends StatelessWidget {
  final bool _puzzleAnswered;
  final Function _showAnswerCallback;
  final Function _correctAnswerCallback;
  final Function _incorrectAnswerCallback;

  AnswerButtonsWidget(this._puzzleAnswered, this._showAnswerCallback,
      this._correctAnswerCallback, this._incorrectAnswerCallback);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_puzzleAnswered) {
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
}
