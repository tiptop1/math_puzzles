class Session {
  final int maxQuestionsCount;
  int _correctAnswersCount;
  int get correctAnswersCount => _correctAnswersCount;

  int _incorrectAnswersCount;
  int get incorrectAnswersCount => _incorrectAnswersCount;

  Session(this.maxQuestionsCount) : _correctAnswersCount = 0, _incorrectAnswersCount = 0;

  void increaseCorrectAnswersCount() {
    _correctAnswersCount++;
  }

  void increaseIncorrectAnswersCount() {
    _incorrectAnswersCount++;
  }
}