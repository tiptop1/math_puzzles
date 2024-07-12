import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/config/configuration.dart';
import '../data/lecture.dart';
import '../utils/app_constants.dart';

class StatusBarWidget extends StatelessWidget {
  static const statusSeparator = '|';

  final Lecture _lecture;

  StatusBarWidget(this._lecture);

  @override
  Widget build(BuildContext context) {
    var puzzlesCount = GetIt.I
        .get<Configuration>()
        .parameters[Configuration.sessionsPuzzlesCountParam] as int;
    var correctAnswersCount = _lecture.correctAnswersCount;
    var incorrectAnswersCount = _lecture.incorrectAnswersCount;
    var textStyle = Theme.of(context).textTheme.headlineMedium;
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
          style: textStyle?.apply(color: AppConstants.correctAnswerColor),
        ),
        Text(statusSeparator, style: textStyle),
        Text(
          '$incorrectAnswersCount',
          style: textStyle?.apply(color: AppConstants.incorrectAnswerColor),
        ),
      ],
    );
  }
}