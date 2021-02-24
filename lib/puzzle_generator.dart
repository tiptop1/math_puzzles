import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:reflectable/capability.dart';
import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector() : super(metadataCapability);
}

const metadataReflector = Reflector();

@metadataReflector
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
    validators: [IntTypeValidator(), NumParameterScopeValidator(1, 10000)])
@ParameterDefinition(AdditionPuzzleGenerator.paramFractionDigits, 0,
    validators: [IntTypeValidator(), NumParameterScopeValidator(0, 4)])
@metadataReflector
class AdditionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'additionGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';
  static const String paramFractionDigits = '$_name.fractionDigits';

  final Random _random;

  const AdditionPuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = _getRequiredParameter(paramMaxResult, parameters);
    var fractionDigits = _getRequiredParameter(paramFractionDigits, parameters);

    // a + b = c
    var c = Decimal.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var a = Decimal.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));

    var b = c - a;

    return Puzzle('$a + $b', '$c');
  }
}

@ParameterDefinition(SubtractionPuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(SubtractionPuzzleGenerator.paramMaxResult, 1000,
    validators: [IntTypeValidator(), NumParameterScopeValidator(1, 10000)])
@ParameterDefinition(SubtractionPuzzleGenerator.paramFractionDigits, 0,
    validators: [IntTypeValidator(), NumParameterScopeValidator(0, 4)])
@metadataReflector
class SubtractionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'subtractionGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';
  static const String paramFractionDigits = '$_name.fractionDigits';

  final Random _random;

  const SubtractionPuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = _getRequiredParameter(paramMaxResult, parameters);
    var fractionDigits = _getRequiredParameter(paramFractionDigits, parameters);

    // a - b = c
    var c = Decimal.parse(
        (_random.nextDouble() * maxResult).toStringAsFixed(fractionDigits));
    var b = Decimal.parse(
        (_random.nextDouble() * c.toInt()).toStringAsFixed(fractionDigits));
    var a = c + b;

    return Puzzle('$a - $b', '$c');
  }
}

@ParameterDefinition(MultiplicationTablePuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(
    MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, 10,
    validators: [IntTypeValidator(), NumParameterScopeValidator(10, 1000)])
@metadataReflector
class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'multiplicationTableGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMultiplicationTimes = '$_name.multiplicationTimes';

  final Random _random;

  const MultiplicationTablePuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var multiplicationTimes =
        _getRequiredParameter(paramMultiplicationTimes, parameters) as int;
    var a = _random.nextInt(multiplicationTimes + 1);
    var b = _random.nextInt(multiplicationTimes + 1);
    return Puzzle('$a \u00D7 $b', '${a * b}');
  }
}

@ParameterDefinition(DivisionPuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(DivisionPuzzleGenerator.paramMaxResult, 10,
    validators: [IntTypeValidator(), NumParameterScopeValidator(10, 1000)])
@metadataReflector
class DivisionPuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'divisionGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$_name.maxResult';

  final Random _random;

  const DivisionPuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var maxResult = _getRequiredParameter(paramMaxResult, parameters) as int;
    // a / b = c
    var c = _random.nextInt(maxResult + 1);
    var b = _random.nextInt(maxResult + 1);
    var a = b * c;
    return Puzzle('$a \u00F7 $b', '$c');
  }
}

@ParameterDefinition(PercentagePuzzleGenerator.paramEnabled, true,
    validators: [BoolTypeValidator()])
@ParameterDefinition(PercentagePuzzleGenerator.maxResult, 100,
    validators: [IntTypeValidator(), NumParameterScopeValidator(1, 1000)])
@ParameterDefinition(PercentagePuzzleGenerator.fractionDigits, 2,
    validators: [IntTypeValidator(), NumParameterScopeValidator(0, 4)])
@metadataReflector
class PercentagePuzzleGenerator extends PuzzleGenerator {
  static const String _name = 'percentageGenerator';
  static const String paramEnabled =
      '$_name.${PuzzleGenerator.paramEnabledPostfix}';
  static const String maxResult = '$_name.maxResult';
  static const String fractionDigits = '$_name.fractionDigits';

  final Random _random;

  const PercentagePuzzleGenerator(this._random) : super(_name);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var number = _random.nextInt(_getRequiredParameter(maxResult, parameters));
    var percentage = _random.nextInt(100);
    var result = ((percentage / 100) * number)
        .toStringAsFixed(_getRequiredParameter(fractionDigits, parameters));
    return Puzzle('$percentage% \u00D7 $number', result);
  }
}

class PuzzleGeneratorManager {
  static PuzzleGeneratorManager _instance;

  List<PuzzleGenerator> generators;
  int _enabledGeneratorIndex = -1;

  PuzzleGeneratorManager._internal() {
    var random = Random();
    generators = List.unmodifiable([
      AdditionPuzzleGenerator(random),
      SubtractionPuzzleGenerator(random),
      MultiplicationTablePuzzleGenerator(random),
      DivisionPuzzleGenerator(random),
      PercentagePuzzleGenerator(random)
    ]);
  }

  factory PuzzleGeneratorManager() {
    _instance ??= PuzzleGeneratorManager._internal();
    return _instance;
  }

  /// Returns next enabled generator according to [parameters].
  PuzzleGenerator findNextEnabledGenerator(Map<String, dynamic> parameters) {
    var nextEnabledGenerator;
    var enabledGenerators = _findEnabledGenerators(parameters);
    assert(enabledGenerators.isNotEmpty,
        'All puzzle generators had been disable - at lease one must be enabled.');

    var i;
    var nextEnabledGeneratorIndex =
        (_enabledGeneratorIndex < generators.length - 1
            ? _enabledGeneratorIndex + 1
            : 0);

    // Look for generator in index scope [nextEnabledGeneratorIndex, this.generators.length - 1]
    for (i = nextEnabledGeneratorIndex; i < generators.length; i++) {
      if (enabledGenerators.containsKey(i)) {
        nextEnabledGenerator = enabledGenerators[i];
        break;
      }
    }

    // If enabled generator not found in first pass,
    // look for generator in index scope [0, nextEnabledGeneratorIndex)
    if (nextEnabledGenerator == null) {
      for (i = 0; i < nextEnabledGeneratorIndex; i++) {
        if (enabledGenerators.containsKey(i)) {
          nextEnabledGenerator = enabledGenerators[i];
          break;
        }
      }
    }

    _enabledGeneratorIndex = (nextEnabledGenerator != null ? i : -1);

    return nextEnabledGenerator;
  }

  /// Returns true if generator named [generatorName] is enabled
  /// according to [parameters], otherwise false.
  bool _isGeneratorEnabled(
      String generatorName, Map<String, dynamic> parameters) {
    var enabled = true;
    var paramName = '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
    if (parameters.containsKey(paramName)) {
      enabled = parameters[paramName];
    }
    return enabled;
  }

  /// Returns mapping index:generator for generator enabled by [parameters].
  Map<int, PuzzleGenerator> _findEnabledGenerators(
      Map<String, dynamic> parameters) {
    var enabledGenerators = <int, PuzzleGenerator>{};

    for (var i = 0; i < generators.length; i++) {
      var gen = generators[i];
      if (_isGeneratorEnabled(gen.name, parameters)) {
        enabledGenerators[i] = gen;
      }
    }

    return enabledGenerators;
  }
}
