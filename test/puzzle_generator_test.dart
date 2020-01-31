import 'package:decimal/decimal.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:test/test.dart';
import 'package:math_puzzles/puzzle_generator.dart';

final RegExp operandRegexp = RegExp('\\d+(\.\\d+)?');
RandomPuzzleGenerator generator = RandomPuzzleGenerator();

main() {
  test('generatePuzzle(OperationType.integerAddition)', () {
    Puzzle puzzle = generator.generatePuzzle(OperationType.integerAddition);
    String question = puzzle.question;
    expect(question, isNotNull);

    int o1 = int.parse(getOperand(question, 0));
    int o2 = int.parse(getOperand(question, 1));
    int result = int.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
  });

  test('generatePuzzle(OperationType.doubleAddition)', () {
    Puzzle puzzle = generator.generatePuzzle(OperationType.doubleAddition);
    String question = puzzle.question;
    expect(question, isNotNull);

    Decimal o1 = Decimal.parse(getOperand(question, 0));
    Decimal o2 = Decimal.parse(getOperand(question, 1));
    Decimal result = Decimal.parse(puzzle.answer);

    expect(result, equals(o1 + o2));
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
