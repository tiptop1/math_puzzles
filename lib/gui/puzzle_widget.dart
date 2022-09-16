import 'package:flutter/material.dart';

import '../data/lecture.dart';
import '../utils/app_constnts_widget.dart';

class PuzzleWidget extends StatelessWidget {
  final Lecture _lecture;

  PuzzleWidget(this._lecture);

  @override
  Widget build(BuildContext context) {
    var answerTheme = Theme.of(context).textTheme.headline5;
    return Text.rich(
      TextSpan(
        text: '${_lecture.puzzle.question} = ',
        children: <TextSpan>[
          TextSpan(
            text: _lecture.puzzleAnswered ? '${_lecture.puzzle.answer}' : '?',
            style: answerTheme?.apply(color: AppConstants.answerColor),
          ),
        ],
        style: answerTheme,
      ),
      // textScaleFactor: 2.0,
    );
  }
}