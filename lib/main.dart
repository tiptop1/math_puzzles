import 'package:flutter/material.dart';

import 'package:math_puzzles/puzzle.dart';
import 'package:math_puzzles/puzzle_generator.dart';

void main() => runApp(MathPuzzleWidget());

class MathPuzzleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MathPuzzleState();
}

class _MathPuzzleState extends State<MathPuzzleWidget> {
  Puzzle _puzzle =
      RandomPuzzleGenerator().generatePuzzle(OperationType.integerAddition);
  bool _puzzleAnswered = false;

  _showQuestionCallback() {
    setState(() {
      _puzzle =
          RandomPuzzleGenerator().generatePuzzle(OperationType.integerAddition);
      _puzzleAnswered = false;
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
      home: Scaffold(
          appBar: AppBar(title: const Text('Mapth Puzzle')),
          body: Column(
            children: [
              Text(
                  '${_puzzle.question} = ${_puzzleAnswered ? _puzzle.answer : '?'}'),
              AnswerButtonsWidget(
                  _puzzleAnswered, _showAnswerCallback, _showQuestionCallback),
            ],
          )),
    );
  }
}

class AnswerButtonsWidget extends StatelessWidget {
  final bool _puzzleAnswered;
  final Function _showAnswerCallback;
  final Function _showQuestionCallback;

  AnswerButtonsWidget(this._puzzleAnswered, this._showAnswerCallback,
      this._showQuestionCallback);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_puzzleAnswered) {
      widget = RaisedButton(
        child: Text('Show answer'),
        onPressed: _showAnswerCallback,
      );
    } else {
      widget = Row(
        children: [
          RaisedButton(child: Text('Fail'), onPressed: _showQuestionCallback),
          RaisedButton(
              child: Text('Correct'), onPressed: _showQuestionCallback),
        ],
      );
    }
    return widget;
  }
}
