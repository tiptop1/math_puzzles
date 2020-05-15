import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/puzzle.dart';

abstract class PuzzleGenerator {
  static const String paramEnabledPostfix = "enabled";
  final String name;
  final Map<String, Object> defaultParameters;

  PuzzleGenerator(this.name, this.defaultParameters);

  Puzzle generate(Map<String, Object> parameters);

  bool containsRequiredParameters(Map<String, Object> parameters);

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
  static const String paramEnabled = '$_name.${PuzzleGenerator.paramEnabledPostfix}';
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
  bool containsRequiredParameters(Map<String, Object> parameters) =>
      parameters != null &&
      parameters.containsKey(DoubleAdditionPuzzleGenerator.paramMaxResult) &&
      parameters.containsKey(DoubleAdditionPuzzleGenerator.paramPrecision);

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

class IntegerAdditionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'integerAdditionPuzzleGenerator';
  static const String paramEnabled = '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';

  final Random _random;

  IntegerAdditionPuzzleGenerator(this._random)
      : super(IntegerAdditionPuzzleGenerator._name, {
          IntegerAdditionPuzzleGenerator.paramEnabled: true,
          IntegerAdditionPuzzleGenerator.paramMaxResult: 1000
        });

  @override
  bool containsRequiredParameters(Map<String, Object> parameters) =>
      parameters != null &&
      parameters.containsKey(IntegerAdditionPuzzleGenerator.paramMaxResult);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int maxResult = _getRequiredParameter(
        IntegerAdditionPuzzleGenerator.paramMaxResult, parameters);
    // a + b = c
    int c = _random.nextInt(maxResult);
    int a = _random.nextInt(c);
    int b = c - a;

    return Puzzle('$a + $b', '$c');
  }
}
