import 'package:flutter/material.dart';

import '../data/config/configuration.dart';
import '../gui/parameter_definition/parameter_converters.dart';
import '../gui/parameter_definition/parameter_definition.dart';
import '../gui/parameter_definition/parameter_validators.dart';

// ignore_for_file: lines_longer_than_80_chars
class AppConstants {
  static const correctAnswerColor = Colors.green;
  static const incorrectAnswerColor = Colors.red;
  static const answerColor = Colors.blue;

  // TODO: Parameter definitions - it should be moved in better place.
  static List<ParameterDefinition> parameterDefinitions = [
    GroupParameterDefinition(Configuration.sesstionGroup, [
      ValueParameterDefinition<int>(
        Configuration.sessionsPuzzlesCountParam,
        IntValueConverter(),
        validators: [
          IntParameterScopeValidator(1, 100),
        ],
      ),
    ]),
    GroupParameterDefinition(Configuration.additionGroup, [
      ValueParameterDefinition(
          Configuration.additionEnabledParam, BoolValueConverter()),
      ValueParameterDefinition(
          Configuration.additionMaxResultParam, IntValueConverter(),
          validators: [IntParameterScopeValidator(1, 10000)]),
      ValueParameterDefinition(
        Configuration.additionFractionDigits,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(0, 4)],
      ),
    ]),
    GroupParameterDefinition(Configuration.subtractionGroup, [
      ValueParameterDefinition(
          Configuration.subtractionEnabledParam, BoolValueConverter()),
      ValueParameterDefinition(
        Configuration.subtractionMaxResultParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(1, 10000)],
      ),
      ValueParameterDefinition(
        Configuration.subtractionFractionDigitsParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(0, 4)],
      ),
    ]),
    GroupParameterDefinition(Configuration.multiplicationTableGroup, [
      ValueParameterDefinition(
          Configuration.multiplicationTableEnabledParam, BoolValueConverter()),
      ValueParameterDefinition(
        Configuration.multiplicationTableTimesParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(10, 1000)],
      ),
    ]),
    GroupParameterDefinition(Configuration.divisionGroup, [
      ValueParameterDefinition(
          Configuration.divisionEnabledParam, BoolValueConverter()),
      ValueParameterDefinition(
        Configuration.divisionMaxResultParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(10, 1000)],
      )
    ]),
    GroupParameterDefinition(Configuration.percentageGroup, [
      ValueParameterDefinition(
          Configuration.percentageEnabledParam, BoolValueConverter()),
      ValueParameterDefinition(
        Configuration.percentageMaxResultParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(1, 1000)],
      ),
      ValueParameterDefinition(
        Configuration.percentageFractionDigitsParam,
        IntValueConverter(),
        validators: [IntParameterScopeValidator(0, 4)],
      ),
    ]),
  ];
}
