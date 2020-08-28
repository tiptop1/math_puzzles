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
  static const String paramEnabledPostfix = 'enabled';
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

@ParameterDefinition(AdditionPuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(AdditionPuzzleGenerator.paramMaxResult, 1000,
    validators: [IntTypeValidator(), ScopeParameterValidator(1, 10000)])
@ParameterDefinition(AdditionPuzzleGenerator.paramFractionDigits, 0,
    validators: [IntTypeValidator(), ScopeParameterValidator(0, 4)])
@reflector
class AdditionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'additionalPuzzleGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';
  static const String paramFractionDigits = '$_name.fractionDigits';

  final Random _random;

  AdditionPuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    int maxResult = _getRequiredParameter(
        AdditionPuzzleGenerator.paramMaxResult, parameters);
    int fractionDigits = _getRequiredParameter(
        AdditionPuzzleGenerator.paramFractionDigits, parameters);

    // a + b = c
    var c = Decimal.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var a = Decimal.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));

    var b = c - a;

    return Puzzle('$a + $b', '$c');
  }
}

@ParameterDefinition(MultiplicationTablePuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(
    MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, 10,
    validators: [IntTypeValidator(), ScopeParameterValidator(10, 1000)])
@reflector
class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'MultiplicationTableGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMultiplicationTimes = '$_name.multiplicationTimes';

  final Random _random;

  MultiplicationTablePuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var a = _random.nextInt((_getRequiredParameter(
            MultiplicationTablePuzzleGenerator.paramMultiplicationTimes,
            parameters) as int) +
        1);
    var b = _random.nextInt((_getRequiredParameter(
            MultiplicationTablePuzzleGenerator.paramMultiplicationTimes,
            parameters) as int) +
        1);
    return Puzzle('$a * $b', '${a * b}');
  }
}

class PuzzleGeneratorManager {
  static final Random _random = Random();
  static List<PuzzleGenerator> generators = [
    AdditionPuzzleGenerator(_random),
    MultiplicationTablePuzzleGenerator(_random)
  ];

  int _generatorIndex = 0;
  static PuzzleGeneratorManager _instance;

  PuzzleGeneratorManager._internal();

  static PuzzleGeneratorManager instance() {
    _instance ??= PuzzleGeneratorManager._internal();
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
    if (generators.isEmpty) {
      nextGenerator = generators[0];
    } else {
      int nextGeneratorIndex;
      do {
        nextGeneratorIndex = _findNextGeneratorIndex();
        var tmpGenerator = generators[nextGeneratorIndex];
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
    var enabled = true;
    var paramName = '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
    if (parameters.containsKey(paramName)) {
      enabled = parameters[paramName];
    }
    return enabled;
  }
}
