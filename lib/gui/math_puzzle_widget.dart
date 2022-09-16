import 'package:flutter/material.dart';

import '../data/lecture.dart';
import 'buttons_widget.dart';
import 'puzzle_widget.dart';
import 'status_bar_widget.dart';

class MathPuzzleWidget extends StatelessWidget {
  final Lecture _lecture;

  const MathPuzzleWidget(this._lecture);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: PuzzleWidget(_lecture),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ButtonsWidget(_lecture),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: StatusBarWidget(_lecture),
          ),
        ),
      ],
    );
  }
}