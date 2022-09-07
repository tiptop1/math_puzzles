import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzles/generated/l10n.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';

import '../model.dart';
import 'color_scheme_extensions.dart';

class SessionSummaryRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).sessionSummaryTitle),
          leading: null,
          automaticallyImplyLeading: false,
          actions: createActions(context),
        ),
        body: Flex(
          direction: screenSize.width > screenSize.height
              ? Axis.horizontal
              : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                      enabled: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 100.0,
                    sections: _createSections(context)),
              ),
            ),
            Expanded(
              flex: 1,
              child: _createLegend(context),
            ),
          ],
        ));
  }

  List<PieChartSectionData> _createSections(BuildContext context) {
    var sessionModel =
        ModalRoute.of(context)!.settings.arguments as SessionModel;
    var correctAnswersCount = sessionModel.correctAnswersCount;
    var incorrectAnswersCount = sessionModel.incorrectAnswersCount;
    var totalAnswersCount = correctAnswersCount + incorrectAnswersCount;
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.correctAnswer,
            value: correctAnswersCount.toDouble(),
            title:
                '$correctAnswersCount (${_calculatePercent(correctAnswersCount, totalAnswersCount)}%)',
            radius: 60.0,
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.incorrectAnswer,
            value: incorrectAnswersCount.toDouble(),
            title:
                '$incorrectAnswersCount (${_calculatePercent(incorrectAnswersCount, totalAnswersCount)}%)',
            radius: 60.0,
          );
        default:
          throw Error();
      }
    });
  }

  int _calculatePercent(num value, num wholeValue) {
    return ((value * 100) / wholeValue).round();
  }

  Widget _createLegend(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LegendItem(AppLocalizations.of(context).correctAnswers,
              Theme.of(context).colorScheme.correctAnswer),
          SizedBox(height: 5),
          LegendItem(AppLocalizations.of(context).incorrectAnswers,
              Theme.of(context).colorScheme.incorrectAnswer),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  static const double size = 20;
  static const double textGap = 4;
  final String _text;
  final Color _color;

  const LegendItem(this._text, this._color);

  @override
  Widget build(BuildContext buildContext) {
    return Row(children: [
      Container(
        color: _color,
        width: size,
        height: size,
      ),
      SizedBox(
        width: textGap,
      ),
      Text(_text),
    ]);
  }
}
