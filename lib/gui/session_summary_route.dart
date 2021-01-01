import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';
import 'package:math_puzzles/localizations.dart';

import '../model.dart';
import 'color_scheme_extensions.dart';

class SessionSummaryRoute extends StatelessWidget {
  // TODO: Try to use Donut Pie Chart with percentage of correct answer inside (charts_flutter library).
  @override
  Widget build(BuildContext context) {
    var sessionModel =
        ModalRoute.of(context).settings.arguments as SessionModel;
    var contextTheme = Theme.of(context);
    var textThemeHeadline2 = contextTheme.textTheme.headline2;
    var textThemeHeadline4 = contextTheme.textTheme.headline4;
    var totalAnswersCount =
        sessionModel.correctAnswersCount + sessionModel.incorrectAnswersCount;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sessionSummary),
        leading: null,
        automaticallyImplyLeading: false,
        actions: createActions(context),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(context).correctAnswers}: ',
                  style: textThemeHeadline4),
              Text(
                '${sessionModel.correctAnswersCount}',
                style: textThemeHeadline4.apply(
                    color: contextTheme.colorScheme.correctAnswer),
              ),
              Text(
                '/',
                style: textThemeHeadline4,
              ),
              Text(
                '${totalAnswersCount}',
                style: textThemeHeadline4.apply(
                    color: contextTheme.colorScheme.incorrectAnswer),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: charts.PieChart(
                    _createSeriesList(context, sessionModel),
                    animate: false,
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 50,
                      startAngle: 4 / 5 * pi,
                      arcLength: 7 / 5 * pi,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${_calculatePercent(sessionModel.correctAnswersCount, totalAnswersCount)}%',
                    style: textThemeHeadline2.apply(
                        color: Theme.of(context).colorScheme.correctAnswer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series> _createSeriesList(
      BuildContext context, SessionModel sessionModel) {
    return [
      charts.Series<AnswersCount, String>(
        id: 'AnswersCount',
        domainFn: (AnswersCount answersCount, _) => answersCount.category,
        measureFn: (AnswersCount answersCount, _) => answersCount.count,
        colorFn: (AnswersCount answersCount, _) => answersCount.color,
        data: [
          AnswersCount(
              sessionModel.correctAnswersCount,
              AppLocalizations.of(context).correctAnswers,
              charts.ColorUtil.fromDartColor(
                  Theme.of(context).colorScheme.correctAnswer)),
          AnswersCount(
              sessionModel.incorrectAnswersCount,
              AppLocalizations.of(context).incorrectAnswers,
              charts.ColorUtil.fromDartColor(
                  Theme.of(context).colorScheme.incorrectAnswer)),
        ],
      )
    ];
  }

  int _calculatePercent(int value, int wholeValue) {
    return ((value * 100) / wholeValue).round();
  }
}

class AnswersCount {
  final int count;
  final String category;
  final charts.Color color;

  AnswersCount(this.count, this.category, this.color);
}
