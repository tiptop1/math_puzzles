import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:math_puzzles/data/config/configuration.dart';
import 'package:math_puzzles/data/lecture.dart';
import 'package:math_puzzles/utils/puzzle_generator.dart';

import '../data/puzzle.dart';
import 'bloc.dart';

class MathPuzzleBloc extends Bloc {
  final StreamController<Lecture?> controller = StreamController<Lecture?>();
  late Sink<Lecture?> sink;
  late Stream<Lecture?> stream;
  late PuzzleGeneratorManager generatorManager;
  late Configuration configuration;

  MathPuzzleBloc() {
    generatorManager = PuzzleGeneratorManager();
    sink = controller.sink;
    sink.add(_initialLecture());
    stream = controller.stream;
    configuration = GetIt.I.get<Configuration>();
  }

  void puzzleAnswered(Lecture lecture) => sink.add(Lecture(lecture.puzzle, true,
      lecture.correctAnswersCount, lecture.incorrectAnswersCount));

  void rateAnswer(bool correct, Lecture lecture) {
    var correctAnswersCount = lecture.correctAnswersCount;
    var incorrectAnswersCount = lecture.incorrectAnswersCount;
    if (correct) {
      correctAnswersCount++;
    } else {
      incorrectAnswersCount++;
    }
    sink.add(Lecture(
        lecture.puzzle, true, correctAnswersCount, incorrectAnswersCount));
  }

  void nextPuzzle(Lecture lecture) {
    var sessionsPuzzlesCount = configuration
        .parameters[Configuration.sessionsPuzzlesCountParam] as int;
    var nextLecture;
    if (lecture.correctAnswersCount + lecture.incorrectAnswersCount <
        sessionsPuzzlesCount) {
      nextLecture = Lecture(_generatePuzzle(), false,
          lecture.correctAnswersCount, lecture.incorrectAnswersCount);
    }
    sink.add(nextLecture);
  }

  void resetSession() => sink.add(_initialLecture());

  @override
  void dispose() {
    controller.close();
  }

  Lecture _initialLecture() => Lecture(_generatePuzzle(), false, 0, 0);

  Puzzle _generatePuzzle() {
    var params = configuration.parameters;
    return generatorManager.findNextEnabledGenerator(params).generate(params);
  }
}
