import 'puzzle.dart';

class Lecture {
  final Puzzle puzzle;
  final bool puzzleAnswered;
  final bool finished;
  final int correctAnswersCount;
  final int incorrectAnswersCount;

  const Lecture(this.puzzle, this.puzzleAnswered, this.finished,
      this.correctAnswersCount, this.incorrectAnswersCount);

  Lecture copyWith(
      {Puzzle? puzzle,
      bool? puzzleAnswered,
      bool? finished,
      int? correctAnswersCount,
      int? incorrectAnswersCount}) {
    return Lecture(
        puzzle ?? this.puzzle,
        puzzleAnswered ?? this.puzzleAnswered,
        finished ?? this.finished,
        correctAnswersCount ?? this.correctAnswersCount,
        incorrectAnswersCount ?? this.incorrectAnswersCount);
  }
}
