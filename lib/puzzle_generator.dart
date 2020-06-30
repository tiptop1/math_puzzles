import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/puzzle.dart';

abstract class PuzzleGenerator {
  static const String paramEnabledPostfix = "enabled";
  final String name;
  final Map<String, Object> defaultParameters;

  PuzzleGenerator(this.name, this.defaultParameters);

  Puzzle generate(Map<String, Object> parameters);

  Object _getRequiredParameter(String name, Map<String, Object> parameters) {
    if (parameters.containsKey(name)) {
      return parameters[name];
    } else {
      throw Exception('Required paramerter "$name" not provided.');
    }
  }
}

class DoubleAdditionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'doubleAdditionalPuzzleGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';
  static const String paramPrecision = '$_name.precision';

  final Random _random;

  DoubleAdditionPuzzleGenerator(this._random)
      : super(DoubleAdditionPuzzleGenerator._name, {
          DoubleAdditionPuzzleGenerator.paramEnabled: true,
          DoubleAdditionPuzzleGenerator.paramMaxResult: 1000,
          DoubleAdditionPuzzleGenerator.paramPrecision: 2
        });

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int maxResult = _getRequiredParameter(
        DoubleAdditionPuzzleGenerator.paramMaxResult, parameters);
    int precision = _getRequiredParameter(
        DoubleAdditionPuzzleGenerator.paramPrecision, parameters);

    // a + b = c
    Decimal c = Decimal.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(precision));
    Decimal a = Decimal.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(precision));

    Decimal b = Decimal.parse(c.toString()) - Decimal.parse(a.toString());

    return Puzzle('$a + $b', '$c');
  }
}

class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'MultiplicationTableGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMultiplicationTimes = '$_name.multiplicationTimes';

  final Random _random;

  MultiplicationTablePuzzleGenerator(this._random)
      : super(MultiplicationTablePuzzleGenerator._name, {
          MultiplicationTablePuzzleGenerator.paramEnabled: true,
          MultiplicationTablePuzzleGenerator.paramMultiplicationTimes: 10
        });

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int a = _random.nextInt((_getRequiredParameter(MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, parameters) as int) + 1);
    int b = _random.nextInt((_getRequiredParameter(MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, parameters) as int) + 1);
    return Puzzle('$a + $b', '${a * b}');
  }
}
