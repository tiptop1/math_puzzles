import 'dart:math';

import 'package:math_puzzles/data/config/configuration.dart';
import 'package:math_puzzles/puzzle_generators/addition_puzzle_generator.dart';
import 'package:math_puzzles/puzzle_generators/multiplication_table_puzzle_generator.dart';
import 'package:math_puzzles/puzzle_generators/puzzle_generator.dart';
import 'package:test/test.dart';

final RegExp operandRegexp = RegExp('\\d+(\.\\d+)?');

void main() {
  var _random = Random();
  test('AdditionPuzzleGenerator_integerAddition', () {
    PuzzleGenerator generator = AdditionPuzzleGenerator(_random);

    var paramValues = {
      Configuration.additionMaxResultParam: 1000,
      Configuration.additionFractionDigits: 0
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

    var defaultParams = <String, Object>{
      Configuration.additionMaxResultParam: 1000,
      Configuration.additionFractionDigits: 2
    };

    var puzzle = generator.generate(defaultParams);
    var question = puzzle.question;
    expect(question, isNotNull);

    var o1 = num.parse(getOperand(question, 0));
    var o2 = num.parse(getOperand(question, 1));
    var result = num.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('MultiplicationTablePuzzleGenerator', () {
    PuzzleGenerator generator = MultiplicationTablePuzzleGenerator(_random);

    var defaultParams = <String, Object>{
      Configuration.multiplicationTableTimesParam: 10
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
