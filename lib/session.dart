import 'package:math_puzzles/puzzle_generator.dart';

import 'configuration.dart';
import 'puzzle.dart';

class Session {
  int _correctAnswersCount;

  int get correctAnswersCount => _correctAnswersCount;

  int _incorrectAnswersCount;

  int get incorrectAnswersCount => _incorrectAnswersCount;

  Configuration _configuration;

  bool puzzleAnswered;

  int _currentGeneratorIndex;

  Puzzle _currentPuzzle;

  Puzzle get currentPuzzle => _currentPuzzle;

  Session(this._configuration)
      : _currentGeneratorIndex = 0,
        _correctAnswersCount = 0,
        _incorrectAnswersCount = 0,
        puzzleAnswered = false {
    _currentPuzzle = generateNewPuzzle();
  }

  void increaseCorrectAnswersCount() => _correctAnswersCount++;

  void increaseIncorrectAnswersCount() => _incorrectAnswersCount++;

  Puzzle generateNewPuzzle() {
    PuzzleGenerator generator = _findNextEnabledGenerator();
    assert(generator != null);
    Map<String, Object> parameters = _prepareGeneratorParameters(generator.name);
    puzzleAnswered = false;
    _currentPuzzle = generator.generate(parameters);
    return currentPuzzle;
  }

  int _findNextGeneratorIndex() {
    int index;
    if (_currentGeneratorIndex == _configuration.availableGenerators.length - 1) {
      index = 0;
    } else {
      index = _currentGeneratorIndex + 1;
    }
    return index;
  }

  PuzzleGenerator _findNextEnabledGenerator() {
    PuzzleGenerator nextGenerator;
    List<PuzzleGenerator> availableGenerators = _configuration.availableGenerators;
    if (availableGenerators.length == 0) {
      nextGenerator = availableGenerators[0];
    } else {
      int nextGeneratorIndex;
      do {
        nextGeneratorIndex = _findNextGeneratorIndex();
        PuzzleGenerator tmpGenerator = availableGenerators[nextGeneratorIndex];
        if (_isGeneratorEnabled(tmpGenerator.name)) {
          _currentGeneratorIndex = nextGeneratorIndex;
          nextGenerator = tmpGenerator;
          break;
        }
      } while (nextGeneratorIndex == _currentGeneratorIndex - 1);
    }
    return nextGenerator;
  }

  bool _isGeneratorEnabled(String generatorName) {
    bool enabled = true;
    String paramName = '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
    if (_configuration.parameters.containsKey(paramName)) {
      enabled = _configuration.parameters[paramName];
    }
    return enabled;
  }

  Map<String, Object> _prepareGeneratorParameters(String generatorName) {
    Map<String, Object> generatorParams = {};
    _configuration.parameters.forEach((key, value) {
      if (key.startsWith(generatorName)) {
        generatorParams[key] = value;
      }
    });
    return Map.unmodifiable(generatorParams);
  }
}
