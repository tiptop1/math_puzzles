import 'dart:math';

import '../data/config/configuration.dart';
import '../data/puzzle.dart';
import 'puzzle_generator.dart';

class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  final Random _random;

  const MultiplicationTablePuzzleGenerator(this._random);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var multiplicationTimes = getRequiredParameter(
        Configuration.multiplicationTableTimesParam, parameters) as int;
    var a = _random.nextInt(multiplicationTimes + 1);
    var b = _random.nextInt(multiplicationTimes + 1);
    return Puzzle('$a \u00D7 $b', '${a * b}');
  }

  @override
  bool isEnabled(Map<String, Object> parameters) =>
      parameters.containsKey(Configuration.multiplicationTableEnabledParam)
          ? parameters[Configuration.multiplicationTableEnabledParam] as bool
          : false;
}
