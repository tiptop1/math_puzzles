import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:math_puzzles/data/config/configuration.dart';
import 'package:math_puzzles/generated/l10n.dart';

import '../data/lecture.dart';
import '../utils/app_constants.dart';

class SessionSummaryWidget extends StatelessWidget {
  final Lecture _lecture;

  SessionSummaryWidget(this._lecture);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Flex(
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
        );
  }

  List<PieChartSectionData> _createSections(BuildContext context) {
    var sessionAnswersCount = GetIt.I.get<Configuration>().parameters[Configuration.sessionsPuzzlesCountParam] as int;
    var correctAnswersCount = _lecture.correctAnswersCount.toDouble();
    var incorrectAnswersCount = _lecture.incorrectAnswersCount.toDouble();
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppConstants.correctAnswerColor,
            value: correctAnswersCount,
            title:
                '$correctAnswersCount (${_calculatePercent(correctAnswersCount, sessionAnswersCount)}%)',
            radius: 60.0,
          );
        case 1:
          return PieChartSectionData(
            color: AppConstants.incorrectAnswerColor,
            value: incorrectAnswersCount,
            title:
                '$incorrectAnswersCount (${_calculatePercent(incorrectAnswersCount, sessionAnswersCount)}%)',
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
    var localizations = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LegendItem(localizations.correctAnswers, AppConstants.correctAnswerColor),
          SizedBox(height: 5),
          LegendItem(localizations.incorrectAnswers, AppConstants.incorrectAnswerColor),
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
