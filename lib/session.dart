class Session {
  int _correctAnswersCount = 0;
  int _incorrectAnswersCount = 0;

  int get correctAnswersCount => _correctAnswersCount;

  void increaseCorrectAnswersCount() => _correctAnswersCount++;

  int get incorrectAnswersCount => _incorrectAnswersCount;

  void increaseIncorrectAnswersCount() => _incorrectAnswersCount++;
}
