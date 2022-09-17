import 'dart:math';

import '../data/config/configuration.dart';
import '../data/puzzle.dart';
import 'puzzle_generator.dart';

class PercentagePuzzleGenerator extends PuzzleGenerator {
  final Random _random;

  const PercentagePuzzleGenerator(this._random);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var number = _random.nextInt(getRequiredParameter<int>(
        Configuration.percentageMaxResultParam, parameters));
    var percentage = _random.nextInt(100);
    var result = ((percentage / 100) * number).toStringAsFixed(
        getRequiredParameter<int>(
            Configuration.percentageFractionDigitsParam, parameters));
    return Puzzle('$percentage% \u00D7 $number', result);
  }

  @override
  bool isEnabled(Map<String, Object> parameters) =>
      parameters.containsKey(Configuration.percentageEnabledParam)
          ? parameters[Configuration.percentageEnabledParam] as bool
          : false;
}
