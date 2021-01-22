import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';
import 'package:math_puzzles/localizations.dart';

import '../model.dart';
import 'color_scheme_extensions.dart';

// TODO: Invalid route text.
// TODO: Polish text is to long and overflowing screen.
// TODO: Percentage value overlap chart in landscape position.
class SessionSummaryRoute extends StatelessWidget {
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
          Expanded(
            flex: 1,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${AppLocalizations.of(context).correctAnswers}: '),
                  Text(
                    '${sessionModel.correctAnswersCount}',
                    style: TextStyle(
                        color: contextTheme.colorScheme.correctAnswer),
                  ),
                  Text(
                    '/',
                  ),
                  Text(
                    '${totalAnswersCount}',
                    style: TextStyle(
                        color: contextTheme.colorScheme.incorrectAnswer),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.all(50.0),
              child: charts.PieChart(
                _createSeriesList(context, sessionModel),
                animate: false,
                defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: 30,
                  startAngle: 4 / 5 * pi,
                  arcLength: 7 / 5 * pi,
                ),
                behaviors: [
                  // our title behaviour
                  charts.DatumLegend(
                    position: charts.BehaviorPosition.bottom,
                    outsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    horizontalFirst: false,
                    cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                    showMeasures: true,
                    desiredMaxColumns: 2,
                    desiredMaxRows: 2,
                    legendDefaultMeasure:
                        charts.LegendDefaultMeasure.firstValue,
                    measureFormatter: (num value) =>
                        '${_calculatePercent(value, totalAnswersCount)}%',
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black,
                        fontFamily: 'Roboto',
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )
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
              '${AppLocalizations.of(context).correctAnswers}:',
              charts.ColorUtil.fromDartColor(
                  Theme.of(context).colorScheme.correctAnswer)),
          AnswersCount(
              sessionModel.incorrectAnswersCount,
              '${AppLocalizations.of(context).incorrectAnswers}:',
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
