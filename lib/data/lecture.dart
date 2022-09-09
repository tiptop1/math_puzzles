import 'puzzle.dart';

class Lecture {
  final Puzzle puzzle;
  final bool puzzleAnswered;
  final int correctAnswersCount;
  final int incorrectAnswersCount;

  const Lecture(this.puzzle, this.puzzleAnswered, this.correctAnswersCount, this.incorrectAnswersCount);
}