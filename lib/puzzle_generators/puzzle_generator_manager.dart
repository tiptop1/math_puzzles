import 'dart:math';

import 'package:math_puzzles/puzzle_generators/puzzle_generator.dart';

import 'addition_puzzle_generator.dart';
import 'division_puzzle_generator.dart';
import 'multiplication_table_puzzle_generator.dart';
import 'percentage_puzzle_generator.dart';
import 'subtraction_puzzle_generator.dart';

class PuzzleGeneratorManager {
  static final PuzzleGeneratorManager _instance =
      PuzzleGeneratorManager._internal();

  late List<PuzzleGenerator> generators;
  int _enabledGeneratorIndex = -1;

  PuzzleGeneratorManager._internal() {
    var random = Random();
    generators = List.unmodifiable([
      AdditionPuzzleGenerator(random),
      SubtractionPuzzleGenerator(random),
      MultiplicationTablePuzzleGenerator(random),
      DivisionPuzzleGenerator(random),
      PercentagePuzzleGenerator(random)
    ]);
  }

  factory PuzzleGeneratorManager() => _instance;

  PuzzleGenerator findNextEnabledGenerator(Map<String, Object> parameters) {
    var i = findNextEnabledGeneratorIndex(_enabledGeneratorIndex + 1, generators.length - 1, parameters);
    i ??= findNextEnabledGeneratorIndex(0, _enabledGeneratorIndex - 1, parameters);

    if (i == null) {
      throw Exception('Could not find any enabled puzzle generator.');
    } else {
      _enabledGeneratorIndex = i;
      return generators[_enabledGeneratorIndex];
    }
  }

  int? findNextEnabledGeneratorIndex(int startIndex, int endIndex, Map<String, Object> parameters) {
    var enabledIndex;
    if (startIndex < generators.length && endIndex < generators.length) {
      for (var i = startIndex; i <= endIndex; i++) {
        if (generators[i].isEnabled(parameters)) {
          enabledIndex = i;
          break;
        }
      }
    }
    return enabledIndex;
  }

}
