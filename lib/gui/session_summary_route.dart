import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';
import 'package:math_puzzles/localizations.dart';

import '../model.dart';

class SessionSummaryRoute extends StatelessWidget {
  // TODO: Try to use Donut Pie Chart with percentage of correct answer inside (charts_flutter library).
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
      body: Container(
        child: Center(
          child: charts.PieChart(
            _createSeriesList(context, _sessionModel),
            animate: false,
            defaultRenderer: charts.ArcRendererConfig(
              arcWidth: 120,
              // new code below
              arcRendererDecorators: [
                charts.ArcLabelDecorator(
                  showLeaderLines: false,
                  // outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 18),
                  insideLabelStyleSpec: charts.TextStyleSpec(fontSize: 18),
                  labelPosition: charts.ArcLabelPosition.inside,
                )
              ],
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
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                measureFormatter: (num value) => '',
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.black,
                    fontFamily: 'Roboto',
                    fontSize: 16),
              ),
            ],
          ),
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
        labelAccessorFn: (AnswersCount answersCount, _) =>
            answersCount.count.toString(),
        data: [
          AnswersCount(
              sessionModel.correctAnswersCount,
              AppLocalizations.of(context).correctAnswers,
              charts.ColorUtil.fromDartColor(Colors.green)),
          AnswersCount(
              sessionModel.incorrectAnswersCount,
              AppLocalizations.of(context).incorrectAnswers,
              charts.ColorUtil.fromDartColor(Colors.red)),
        ],
      )
    ];
  }
}

class AnswersCount {
  final int count;
  final String category;
  final charts.Color color;

  AnswersCount(this.count, this.category, this.color);
}
