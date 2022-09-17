import 'dart:math';

import '../data/config/configuration.dart';
import '../data/puzzle.dart';
import 'puzzle_generator.dart';

class DivisionPuzzleGenerator extends PuzzleGenerator {
  final Random _random;

  const DivisionPuzzleGenerator(this._random);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = getRequiredParameter<int>(
        Configuration.divisionMaxResultParam, parameters);
    // a / b = c
    var c = _random.nextInt(maxResult + 1);
    var b = _random.nextInt(maxResult) + 1;
    var a = b * c;
    return Puzzle('$a \u00F7 $b', '$c');
  }

  @override
  bool isEnabled(Map<String, Object> parameters) =>
      parameters.containsKey(Configuration.divisionEnabledParam)
          ? parameters[Configuration.divisionEnabledParam] as bool
          : false;
}
