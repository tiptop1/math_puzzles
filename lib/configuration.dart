import 'package:math_puzzles/puzzle_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class could be used as annotation to define default configuration parameters.
class ParameterDefinition {
  final String name;
  final dynamic defaultValue;
  final List<ParameterValidator> validators;

  const ParameterDefinition(this.name, this.defaultValue,
      {this.validators = const []});
}

/// Configuration parameter validator.
abstract class ParameterValidator {
  /// Error message.
  final String message;

  const ParameterValidator(this.message);

  bool isValueValid(dynamic value);
}

/// Predefined value scope validator.
class ScopeParameterValidator extends ParameterValidator {
  final num minValue;
  final num maxValue;

  const ScopeParameterValidator(this.minValue, this.maxValue)
      : super(
            'Invalid parameter value - expected is between $minValue and $maxValue.');

  @override
  bool isValueValid(dynamic value) => minValue <= value && value <= maxValue;
}

class IntTypeValidator extends ParameterValidator {
  const IntTypeValidator()
      : super('Invalid parameter type - expected integer.');

  @override
  bool isValueValid(dynamic value) => value is int;
}

class BoolTypeValidator extends ParameterValidator {
  const BoolTypeValidator() : super('Invalid parameter type - expected bool.');

  @override
  bool isValueValid(dynamic value) => value is bool;
}

/// The class load, keep and store application parameters.
class Configuration {
  final Map<String, dynamic> _parameterValues = {};
  final Map<String, ParameterDefinition> _parameterDefinitions = {};

  /// Created empty configuration with parameter definitions, but without
  /// parameter values
  Configuration._internal() {
    for (var gen in PuzzleGeneratorManager.generators) {
      var paramDefs = _readParameterDefinitions(gen);
      paramDefs.forEach(
          (paramDef) => _parameterDefinitions[paramDef.name] = paramDef);
    }
  }

  static Future<Configuration> load() async {
    var prefs = await SharedPreferences.getInstance();
    var config = Configuration._internal();

    // Load into configuration parameters from SharedPreferences
    var parameterValues = config.parameterValues;
    prefs.getKeys().forEach((k) => config.setParameterValue(k, prefs.get(k)));

    // Load into configuration default generator parameters if not already
    // loaded from SharedPreferences
    PuzzleGeneratorManager.generators.forEach((generator) {
      var defParams = _readDefaultParameterValues(generator);
      defParams.forEach((key, value) {
        if (!parameterValues.containsKey(key)) {
          config.setParameterValue(key, value);
        }
      });
    });

    return config;
  }

  void store() async {
    var prefs = await SharedPreferences.getInstance();
    _parameterValues.forEach((k, v) {
      dynamic value = v.defaultValue;
      if (v is int) {
        prefs.setInt(k, value);
      } else if (v is double) {
        prefs.setDouble(k, value);
      } else if (v is bool) {
        prefs.setBool(k, value);
      } else if (v is String) {
        prefs.setString(k, value);
      } else {
        throw Exception(
            'Value of key $k has unsupported type ${v?.runtimeType}.');
      }
    });
  }

  Map<String, ParameterDefinition> get parameterDefinitions =>
      Map.unmodifiable(_parameterDefinitions);

  Map<String, dynamic> get parameterValues =>
      Map.unmodifiable(_parameterValues);

  void setParameterValue(String name, dynamic value) {
    if (_parameterDefinitions.containsKey(name)) {
      var paramDef = _parameterDefinitions[name];
      // TODO: Maybe value validation should be extracted for further common use.
      for (var v in paramDef.validators) {
        if (!v.isValueValid(value)) {
          throw Exception(
              'Parameter \'$name\' value $value validation fail with message: '
              '"${v.message}".');
        }
      }
      _parameterValues[name] = value;
    } else {
      throw Exception('Definition for parameter \'$name\' unknown.');
    }
  }

  static List<Object> _readMetadata(PuzzleGenerator generator) {
    var typeMirror = reflector.reflectType(generator.runtimeType);
    return typeMirror.metadata;
  }

  static Map<String, dynamic> _readDefaultParameterValues(
      PuzzleGenerator generator) {
    var defaultParams = {};
    for (var obj in _readMetadata(generator)) {
      if (obj is ParameterDefinition) {
        defaultParams[obj.name] = obj.defaultValue;
      }
    }
    return Map.unmodifiable(defaultParams);
  }

  static List<ParameterDefinition> _readParameterDefinitions(
      PuzzleGenerator generator) {
    var defs = [];
    for (var obj in _readMetadata(generator)) {
      if (obj is ParameterDefinition) {
        defs.add(obj);
      }
    }
    return List.unmodifiable(defs);
  }
}
