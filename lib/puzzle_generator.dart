import 'dart:math';

import 'package:decimal/decimal.dart';
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
    Decimal a;
    Decimal b;
    Decimal c;
    if (precision > 0) {
      c = Decimal.parse((randomGenerator.nextDouble() * maxResult).toStringAsFixed(precision));
      a = Decimal.parse((randomGenerator.nextDouble() * c.toInt()).toStringAsFixed(precision));
    } else {
      c = Decimal.fromInt(randomGenerator.nextInt(maxResult));
      a = Decimal.fromInt(randomGenerator.nextInt(c.toInt()));
    }
    b = Decimal.parse(c.toString()) - Decimal.parse(a.toString());

    return AdditionPuzzle('$a + $b', '$c');
  }
}