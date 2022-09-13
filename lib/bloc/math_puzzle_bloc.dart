import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:math_puzzles/data/config/configuration.dart';
import 'package:math_puzzles/data/lecture.dart';
import 'package:math_puzzles/utils/puzzle_generator.dart';

import '../data/puzzle.dart';
import 'bloc.dart';

class MathPuzzleBloc extends Bloc {
  final StreamController<Lecture> _controller = StreamController<Lecture>();
  late Sink<Lecture> _sink;
  late PuzzleGeneratorManager _generatorManager;
  late Configuration _configuration;
  late Lecture _lecture;
  late Stream<Lecture> stream;

  MathPuzzleBloc() {
    _generatorManager = PuzzleGeneratorManager();
    _sink = _controller.sink;
    _lecture = _initialLecture();
    _sink.add(_lecture);
    stream = _controller.stream;
    _configuration = GetIt.I.get<Configuration>();
  }

  void puzzleAnswered() {
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
    _lecture = _lecture.copyWith(
      puzzleAnswered: true,
      correctAnswersCount: correctAnswersCount,
      incorrectAnswersCount: incorrectAnswersCount,
    );
    _sink.add(_lecture);
  }

  void nextPuzzle() {
    var sessionsPuzzlesCount = _configuration
        .parameters[Configuration.sessionsPuzzlesCountParam] as int;
    if (_lecture.correctAnswersCount + _lecture.incorrectAnswersCount <
        sessionsPuzzlesCount) {
      _lecture = _lecture.copyWith(
        puzzle: _generatePuzzle(),
        puzzleAnswered: false,
      );
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
