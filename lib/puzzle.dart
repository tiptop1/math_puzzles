class Puzzle {
  final String question;
  final String answer;

  Puzzle(this.question, this.answer);

  bool isRightAnswer(String answer) => answer?.trim() == this.answer;
}
