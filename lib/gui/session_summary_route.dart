import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/generated/l10n.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';

import '../model.dart';
import 'color_scheme_extensions.dart';

class SessionSummaryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionModel =
        ModalRoute.of(context)!.settings.arguments as SessionModel;
    var totalAnswersCount =
        sessionModel.correctAnswersCount + sessionModel.incorrectAnswersCount;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sessionSummaryTitle),
        leading: null,
        automaticallyImplyLeading: false,
        actions: createActions(context),
      ),
      body: Container(
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
              outsideJustification: charts.OutsideJustification.middleDrawArea,
              horizontalFirst: false,
              cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
              showMeasures: true,
              desiredMaxColumns: 2,
              desiredMaxRows: 2,
              legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
              measureFormatter: (num value) =>
                  '$value (${_calculatePercent(value, totalAnswersCount)}%)',

              entryTextStyle: charts.TextStyleSpec(
                  fontFamily: 'Roboto',
                  fontSize: 20),
            ),
          ],
        ),
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

  int _calculatePercent(num value, num wholeValue) {
    return ((value * 100) / wholeValue).round();
  }
}

class AnswersCount {
  final int count;
  final String category;
  final charts.Color color;

  AnswersCount(this.count, this.category, this.color);
}
