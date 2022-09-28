import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/math_puzzle_bloc.dart';
import '../data/lecture.dart';
import '../generated/l10n.dart';
import '../utils/app_constants.dart';

class ButtonsWidget extends StatelessWidget {
  final Lecture _lecture;

  ButtonsWidget(this._lecture);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    var bloc = BlocProvider.of<MathPuzzleBloc>(context);
    if (!_lecture.puzzleAnswered) {
      widget = ElevatedButton.icon(
        // TODO: Try to find better icon - something like question mark should be OK
        icon: Icon(Icons.help_outline),
        label: Text(AppLocalizations.of(context).showAnswerButton),
        style: ElevatedButton.styleFrom(backgroundColor: AppConstants.answerColor),
        onPressed: () => bloc.markPuzzleAsAnswered(),
      );
    } else {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(flex: 2),
          Expanded(
            flex: 10,
            child: ElevatedButton.icon(
              icon: Icon(Icons.close),
              label: Text(AppLocalizations.of(context).incorrectAnswerButton),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.incorrectAnswerColor),
              onPressed: () => bloc.rateAnswer(false),
            ),
          ),
          Spacer(flex: 2),
          Expanded(
            flex: 10,
            child: ElevatedButton.icon(
              icon: Icon(Icons.check),
              label: Text(
                AppLocalizations.of(context).correctAnswerButton,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.correctAnswerColor),
              onPressed: () => bloc.rateAnswer(true),
            ),
          ),
          Spacer(flex: 2),
        ],
      );
    }
    return widget;
  }
}