import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:math_puzzles/config/parameter.dart';
import 'package:math_puzzles/puzzle.dart';
import 'package:reflectable/capability.dart';
import 'package:reflectable/reflectable.dart';

import 'config/validator.dart';

class Reflector extends Reflectable {
  const Reflector() : super(metadataCapability);
}

const metadataReflector = Reflector();

@metadataReflector
abstract class PuzzleGenerator {
  static const String paramEnabledPostfix = 'enabled';
  final String _name;

  const PuzzleGenerator(this._name);

  String get name => _name;

  Puzzle generate(Map<String, Object> parameters);

  Object _getRequiredParameter(String name, Map<String, Object> parameters) {
    if (parameters.containsKey(name)) {
      return parameters[name];
    } else {
      throw Exception('Required paramerter "$name" not provided.');
    }
  }
}

@metadataReflector
@GroupParameterDefinition(
    AdditionPuzzleGenerator.nname,
    [
      BoolParameterDefinition(AdditionPuzzleGenerator.paramEnabled, true,
          order: 1),
      IntParameterDefinition(AdditionPuzzleGenerator.paramMaxResult, 1000,
          order: 2, validators: [NumParameterScopeValidator(1, 10000)]),
      IntParameterDefinition(AdditionPuzzleGenerator.paramFractionDigits, 0,
          order: 3, validators: [NumParameterScopeValidator(0, 4)]),
    ],
    order: 1)
class AdditionPuzzleGenerator extends PuzzleGenerator {
  static const String nname = 'additionGenerator';
  static const String paramEnabled =
      '$nname.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$nname.maxResult';
  static const String paramFractionDigits = '$nname.fractionDigits';

  final Random _random;

  const AdditionPuzzleGenerator(this._random) : super(nname);

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

@metadataReflector
@GroupParameterDefinition(
    SubtractionPuzzleGenerator.nname,
    [
      BoolParameterDefinition(SubtractionPuzzleGenerator.paramEnabled, true,
          order: 1),
      IntParameterDefinition(SubtractionPuzzleGenerator.paramMaxResult, 1000,
          order: 2, validators: [NumParameterScopeValidator(1, 10000)]),
      IntParameterDefinition(SubtractionPuzzleGenerator.paramFractionDigits, 0,
          order: 3, validators: [NumParameterScopeValidator(0, 4)]),
    ],
    order: 2)
class SubtractionPuzzleGenerator extends PuzzleGenerator {
  static const String nname = 'subtractionGenerator';
  static const String paramEnabled =
      '$nname.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$nname.maxResult';
  static const String paramFractionDigits = '$nname.fractionDigits';

  final Random _random;

  const SubtractionPuzzleGenerator(this._random) : super(nname);

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

@metadataReflector
@GroupParameterDefinition(
    MultiplicationTablePuzzleGenerator.nname,
    [
      BoolParameterDefinition(
          MultiplicationTablePuzzleGenerator.paramEnabled, true,
          order: 1),
      IntParameterDefinition(
          MultiplicationTablePuzzleGenerator.paramMultiplicationTimes, 10,
          order: 2, validators: [NumParameterScopeValidator(10, 1000)]),
    ],
    order: 3)
class MultiplicationTablePuzzleGenerator extends PuzzleGenerator {
  static const String nname = 'multiplicationTableGenerator';
  static const String paramEnabled =
      '$nname.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMultiplicationTimes = '$nname.multiplicationTimes';

  final Random _random;

  const MultiplicationTablePuzzleGenerator(this._random) : super(nname);

  @override
  Puzzle generate(Map<String, Object> parameters) {
    var multiplicationTimes =
        _getRequiredParameter(paramMultiplicationTimes, parameters) as int;
    var a = _random.nextInt(multiplicationTimes + 1);
    var b = _random.nextInt(multiplicationTimes + 1);
    return Puzzle('$a \u00D7 $b', '${a * b}');
  }
}

@metadataReflector
@GroupParameterDefinition(
    DivisionPuzzleGenerator.nname,
    [
      BoolParameterDefinition(DivisionPuzzleGenerator.paramEnabled, true,
          order: 1),
      IntParameterDefinition(DivisionPuzzleGenerator.paramMaxResult, 10,
          order: 2, validators: [NumParameterScopeValidator(10, 1000)]),
    ],
    order: 4)
class DivisionPuzzleGenerator extends PuzzleGenerator {
  static const String nname = 'divisionGenerator';
  static const String paramEnabled =
      '$nname.${PuzzleGenerator.paramEnabledPostfix}';
  static const String paramMaxResult = '$nname.maxResult';

  final Random _random;

  const DivisionPuzzleGenerator(this._random) : super(nname);

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

@metadataReflector
@GroupParameterDefinition(
    PercentagePuzzleGenerator.nname,
    [
      BoolParameterDefinition(PercentagePuzzleGenerator.paramEnabled, true,
          order: 1),
      IntParameterDefinition(PercentagePuzzleGenerator.maxResult, 100,
          order: 2, validators: [NumParameterScopeValidator(1, 1000)]),
      IntParameterDefinition(PercentagePuzzleGenerator.fractionDigits, 2,
          order: 3, validators: [NumParameterScopeValidator(0, 4)])
    ],
    order: 5)
class PercentagePuzzleGenerator extends PuzzleGenerator {
  static const String nname = 'percentageGenerator';
  static const String paramEnabled =
      '$nname.${PuzzleGenerator.paramEnabledPostfix}';
  static const String maxResult = '$nname.maxResult';
  static const String fractionDigits = '$nname.fractionDigits';

  final Random _random;

  const PercentagePuzzleGenerator(this._random) : super(nname);

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
