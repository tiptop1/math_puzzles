import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:reflectable/capability.dart';
import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector() : super(metadataCapability);
}

const reflector = Reflector();

@reflector
abstract class PuzzleGenerator {
  static const String paramEnabledPostfix = "enabled";
  final String name;

  const PuzzleGenerator(this.name);

  Puzzle generate(Map<String, Object> parameters);

  Object _getRequiredParameter(String name, Map<String, Object> parameters) {
    if (parameters.containsKey(name)) {
      return parameters[name];
    } else {
      throw Exception('Required paramerter "$name" not provided.');
    }
  }
}

@ParameterDefinition(DoubleAdditionPuzzleGenerator.paramEnabled, true)
@ParameterDefinition(DoubleAdditionPuzzleGenerator.paramMaxResult, 1000,
    validators: [ScopeParameterValidator(1, 10000)])
@ParameterDefinition(DoubleAdditionPuzzleGenerator.paramFractionDigits, 0,
    validators: [ScopeParameterValidator(0, 4)])
@reflector
class DoubleAdditionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'doubleAdditionalPuzzleGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';
  static const String paramFractionDigits = '$_name.fractionDigits';

  final Random _random;

  DoubleAdditionPuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int maxResult = _getRequiredParameter(
        DoubleAdditionPuzzleGenerator.paramMaxResult, parameters);
    int fractionDigits = _getRequiredParameter(
        DoubleAdditionPuzzleGenerator.paramFractionDigits, parameters);

    // a + b = c
    Decimal c = Decimal.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    Decimal a = Decimal.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));

    Decimal b = c - a;

    return Puzzle('$a + $b', '$c');
  }
}

@ParameterDefinition(MultiplicationTablePuzzleGenerator.paramEnabled, true)
@ParameterDefinition(
    MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, 10,
    validators: [ScopeParameterValidator(10, 1000)])
@reflector
class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'MultiplicationTableGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMultiplicationTimes = '$_name.multiplicationTimes';

  final Random _random;

  MultiplicationTablePuzzleGenerator(this._random)
      : super(MultiplicationTablePuzzleGenerator._name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int a = _random.nextInt((_getRequiredParameter(
            MultiplicationTablePuzzleGenerator.paramMultiplicationTimes,
            parameters) as int) +
        1);
    int b = _random.nextInt((_getRequiredParameter(
            MultiplicationTablePuzzleGenerator.paramMultiplicationTimes,
            parameters) as int) +
        1);
    return Puzzle('$a * $b', '${a * b}');
  }
}

class PuzzleGeneratorManager {
  static Random _random = Random();
  static List<PuzzleGenerator> generators = [
    DoubleAdditionPuzzleGenerator(_random),
    MultiplicationTablePuzzleGenerator(_random)
  ];

  int _generatorIndex = 0;
  static PuzzleGeneratorManager _instance;

  PuzzleGeneratorManager._internal();

  static PuzzleGeneratorManager instance() {
    if (_instance == null) {
      _instance = PuzzleGeneratorManager._internal();
    }
    return _instance;
  }

  int _findNextGeneratorIndex() {
    int index;
    if (_generatorIndex == generators.length - 1) {
      index = 0;
    } else {
      index = _generatorIndex + 1;
    }
    return index;
  }

  /// Returns next available generator.
  PuzzleGenerator findNextGenerator(Map<String, dynamic> parameters) {
    PuzzleGenerator nextGenerator;
    if (generators.length == 0) {
      nextGenerator = generators[0];
    } else {
      int nextGeneratorIndex;
      do {
        nextGeneratorIndex = _findNextGeneratorIndex();
        PuzzleGenerator tmpGenerator = generators[nextGeneratorIndex];
        if (_isGeneratorEnabled(tmpGenerator.name, parameters)) {
          _generatorIndex = nextGeneratorIndex;
          nextGenerator = tmpGenerator;
          break;
        }
      } while (nextGeneratorIndex == _generatorIndex - 1);
    }
    return nextGenerator;
  }

  bool _isGeneratorEnabled(
      String generatorName, Map<String, dynamic> parameters) {
    bool enabled = true;
    String paramName = '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
    if (parameters.containsKey(paramName)) {
      enabled = parameters[paramName];
    }
    return enabled;
  }
}
