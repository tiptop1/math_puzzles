import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:math_puzzles/data/config/configuration.dart';
import 'package:math_puzzles/data/lecture.dart';

import '../data/puzzle.dart';
import '../puzzle_generators/puzzle_generator_manager.dart';
import 'bloc.dart';

class MathPuzzleBloc extends Bloc {
  final StreamController<Lecture> _controller = StreamController<Lecture>();
  late Sink<Lecture> _sink;
  late PuzzleGeneratorManager _generatorManager;
  late Configuration _configuration;
  late Lecture _lecture;
  late Stream<Lecture> stream;

  MathPuzzleBloc() {
    _configuration = GetIt.I.get<Configuration>();
    _generatorManager = PuzzleGeneratorManager();
    _sink = _controller.sink;
    _lecture = _initialLecture();
    _sink.add(_lecture);
    stream = _controller.stream;
  }

  void markPuzzleAsAnswered() {
    _lecture = _lecture.copyWith(puzzleAnswered: true);
    _sink.add(_lecture);
  }

  void rateAnswer(bool correct) {
    var correctAnswersCount = _lecture.correctAnswersCount;
    var incorrectAnswersCount = _lecture.incorrectAnswersCount;
    if (correct) {
      correctAnswersCount++;
    } else {
      incorrectAnswersCount++;
    }
    if (correctAnswersCount + incorrectAnswersCount < (_configuration.parameters[Configuration.sessionsPuzzlesCountParam] as int)) {
      _lecture = Lecture(_generatePuzzle(), false, false, correctAnswersCount, incorrectAnswersCount);
    } else {
      _lecture = _lecture.copyWith(finished: true);
    }
    _sink.add(_lecture);
  }

  void resetSession() {
    _lecture = _initialLecture();
    _sink.add(_lecture);
  }

  @override
  void dispose() {
    _controller.close();
  }

  Lecture _initialLecture() => Lecture(_generatePuzzle(), false, false, 0, 0);

  Puzzle _generatePuzzle() {
    var params = _configuration.parameters;
    return _generatorManager.findNextEnabledGenerator(params).generate(params);
  }
}
