import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';
import 'package:math_puzzles/localizations.dart';

import '../model.dart';

class SessionSummaryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _sessionModel =
        ModalRoute.of(context).settings.arguments as SessionModel;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).sessionSummary),
          leading: null,
          automaticallyImplyLeading: false,
          actions: createActions(context),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: _createCorrectAnswersSummary(
                  context, _sessionModel.correctAnswersCount),
            ),
            Center(
              child: _createIncorrectAnswersSummary(
                  context, _sessionModel.incorrectAnswersCount),
            ),
          ],
        ));
  }

  Widget _createCorrectAnswersSummary(
      BuildContext context, int correctAnswersCount) {
    return Text(
        '${AppLocalizations.of(context).correctAnswersCount} $correctAnswersCount');
  }

  Widget _createIncorrectAnswersSummary(
      BuildContext context, int incorrectAnswersCount) {
    return Text(
        '${AppLocalizations.of(context).incorrectAnswersCount} $incorrectAnswersCount');
  }
}
