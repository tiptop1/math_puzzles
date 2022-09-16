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
    var c = num.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var a = num.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));
    var b = a - c;

    return Puzzle('$a - $b', '$c');
  }
}
