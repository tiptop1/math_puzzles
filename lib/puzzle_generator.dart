import 'dart:math';

import 'package:math_puzzles/puzzle.dart';

enum OperationType {
  integerAddition,
  doubleAddition
}

class RandomPuzzleGenerator {

  static final RandomPuzzleGenerator _instance = RandomPuzzleGenerator
      ._internal();
  static final Random randomGenerator = Random();

  // TODO: Temporary parameters - if future it should be configurable
  static final int maxIntegerAdditionResult = 1000;
  static final int maxDoubleAdditionalResult = 1000;
  static final int doubleAdditionalResultPrecision = 2;

  RandomPuzzleGenerator._internal();

  factory RandomPuzzleGenerator() => _instance;


  Puzzle generatePuzzle(OperationType type) {
    Puzzle newPuzzle;
    switch (type) {
      case OperationType.integerAddition:
        newPuzzle = _generateDoubleAdditionPuzzle(maxIntegerAdditionResult, 0);
        break;
      case OperationType.doubleAddition:
        newPuzzle = _generateDoubleAdditionPuzzle(
            maxDoubleAdditionalResult, doubleAdditionalResultPrecision);
        break;
      default:
        throw UnsupportedError(
            'Operation ${type.toString()} not supported yet!');
    }
    return newPuzzle;
  }

  Puzzle _generateDoubleAdditionPuzzle(int maxResult, int precision) {
    // a + b = c
    num a;
    num b;
    num c;
    if (precision > 0) {
      c = double.parse(
          (randomGenerator.nextDouble() * maxResult).toStringAsFixed(precision));
      a = double.parse(
          (randomGenerator.nextDouble() * (c as int)).toStringAsFixed(precision));
    } else {
      c = randomGenerator.nextInt(maxResult);
      a = randomGenerator.nextInt(c);
    }
    b = c - a;

    return AdditionPuzzle('$a + $b', '$c');
  }
}