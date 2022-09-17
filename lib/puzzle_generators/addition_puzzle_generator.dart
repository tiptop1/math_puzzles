import 'dart:math';

import '../data/config/configuration.dart';
import '../data/puzzle.dart';
import 'puzzle_generator.dart';

class AdditionPuzzleGenerator extends PuzzleGenerator {
  final Random _random;

  const AdditionPuzzleGenerator(this._random);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = getRequiredParameter<int>(
        Configuration.additionMaxResultParam, parameters);
    var fractionDigits = getRequiredParameter<int>(
        Configuration.additionFractionDigits, parameters);

    // a + b = c
    var c = num.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var a = num.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));
    var b = c - a;

    return Puzzle('$a + $b', '$c');
  }

  @override
  bool isEnabled(Map<String, Object> parameters) =>
      parameters.containsKey(Configuration.additionEnabledParam)
          ? parameters[Configuration.additionEnabledParam] as bool
          : false;
}
