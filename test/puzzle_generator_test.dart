import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:test/test.dart';

final RegExp operandRegexp = RegExp('\\d+(\.\\d+)?');

void main() {
  var _random = Random();
  test('AdditionPuzzleGenerator_integerAddition', () {
    PuzzleGenerator generator = AdditionPuzzleGenerator(_random);

    var paramValues = {
      AdditionPuzzleGenerator.paramMaxResult: 1000,
      AdditionPuzzleGenerator.paramFractionDigits: 0
    };

    var puzzle = generator.generate(paramValues);
    var question = puzzle.question;
    expect(question, isNotNull);

    var o1 = int.parse(getOperand(question, 0));
    var o2 = int.parse(getOperand(question, 1));
    var result = int.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('AdditionPuzzleGenerator_doubleAddition', () {
    PuzzleGenerator generator = AdditionPuzzleGenerator(_random);

    var defaultParams = <String, dynamic>{
      AdditionPuzzleGenerator.paramMaxResult: 1000,
      AdditionPuzzleGenerator.paramFractionDigits: 2
    };

    var puzzle = generator.generate(defaultParams);
    var question = puzzle.question;
    expect(question, isNotNull);

    var o1 = Decimal.parse(getOperand(question, 0));
    var o2 = Decimal.parse(getOperand(question, 1));
    var result = Decimal.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('MultiplicationTablePuzzleGenerator', () {
    PuzzleGenerator generator = MultiplicationTablePuzzleGenerator(_random);

    var defaultParams = <String, dynamic>{
      MultiplicationTablePuzzleGenerator.paramMultiplicationTimes: 10
    };

    var puzzle = generator.generate(defaultParams);
    var question = puzzle.question;
    expect(question, isNotNull);

    var a = int.parse(getOperand(question, 0));
    var b = int.parse(getOperand(question, 1));
    var result = int.parse(puzzle.answer);

    expect(result, equals(a * b));
  });
}

String getOperand(String str, int index) {
  var operand = '';
  var matches = operandRegexp.allMatches(str);
  if (matches.length > index) {
    matches.toList(growable: false).asMap().forEach((i, v) {
      if (i == index) {
        operand = str.substring(v.start, v.end);
      }
    });
  }
  return operand;
}
