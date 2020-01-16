abstract class Puzzle {
  final String question;
  final String answer;

  Puzzle(this.question, this.answer);

  bool isRightAnswer(String answer);
}

class AdditionPuzzle extends Puzzle {

  AdditionPuzzle(String question, String answer) : super(question, answer);

  @override
  bool isRightAnswer(String answer) => answer?.trim() == this.answer;
}
