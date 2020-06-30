import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:test/test.dart';

final RegExp operandRegexp = RegExp('\\d+(\.\\d+)?');

main() {
  Random _random = Random();
  test('DoubleAdditionPuzzleGenerator_integerAddition', () {
    PuzzleGenerator generator = DoubleAdditionPuzzleGenerator(_random);
    Map<String, dynamic> params = generator.defaultParameters;
    params[DoubleAdditionPuzzleGenerator.paramPrecision] = 0;
    Puzzle puzzle = generator.generate(generator.defaultParameters);
    String question = puzzle.question;
    expect(question, isNotNull);

    int o1 = int.parse(getOperand(question, 0));
    int o2 = int.parse(getOperand(question, 1));
    int result = int.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('DoubleAdditionPuzzleGenerator_doubleAddition', () {
    PuzzleGenerator generator = DoubleAdditionPuzzleGenerator(_random);
    Puzzle puzzle = generator.generate(generator.defaultParameters);
    String question = puzzle.question;
    expect(question, isNotNull);

    Decimal o1 = Decimal.parse(getOperand(question, 0));
    Decimal o2 = Decimal.parse(getOperand(question, 1));
    Decimal result = Decimal.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('MultiplicationTablePuzzleGenerator', () {
    PuzzleGenerator generator = MultiplicationTablePuzzleGenerator(_random);
    Puzzle puzzle = generator.generate(generator.defaultParameters);
    String question = puzzle.question;
    expect(question, isNotNull);

    int a = int.parse(getOperand(question, 0));
    int b = int.parse(getOperand(question, 1));
    int result = int.parse(puzzle.answer);

    expect(result, equals(a * b));
  });

}

String getOperand(String str, int index) {
  String operand;
  Iterable<RegExpMatch> matches = operandRegexp.allMatches(str);
  if (matches.length > index) {
    matches.toList(growable: false).asMap().forEach((i, v) {
      if (i == index) {
        operand = str.substring(v.start, v.end);
      }
    });
  }
  return operand;
}
