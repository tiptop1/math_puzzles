import 'dart:math';

import '../data/config/configuration.dart';
import '../data/puzzle.dart';
import 'puzzle_generator.dart';

class SubtractionPuzzleGenerator extends PuzzleGenerator {
  final Random _random;

  const SubtractionPuzzleGenerator(this._random);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = getRequiredParameter<int>(
        Configuration.subtractionMaxResultParam, parameters);
    var fractionDigits = getRequiredParameter<int>(
        Configuration.subtractionFractionDigitsParam, parameters);

    // a - b = c
    var a = num.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var b = num.parse(
        (_random.nextDouble() * a.toInt()).toStringAsFixed(fractionDigits));
    var c = num.parse((a - b).toStringAsFixed(fractionDigits));

    return Puzzle('$a - $b', '$c');
  }

  @override
  bool isEnabled(Map<String, Object> parameters) =>
      parameters.containsKey(Configuration.subtractionEnabledParam)
          ? parameters[Configuration.subtractionEnabledParam] as bool
          : false;
}
