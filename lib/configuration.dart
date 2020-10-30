import 'package:math_puzzles/puzzle_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parameter {
  final dynamic _value;
  final ParameterDefinition definition;

  const Parameter(this._value, this.definition);

  dynamic get value => _value;
}

/// The class could be used as annotation to define default configuration parameters.
class ParameterDefinition {
  final String name;
  final dynamic defaultValue;
  final List<ParameterValidator> validators;

  const ParameterDefinition(this.name, this.defaultValue,
      {this.validators = const []});
}

/// Configuration parameter validator.
/// It assume that parameter will be provided as String
abstract class ParameterValidator {
  /// Error message.
  final String errorMessage;

  const ParameterValidator(this.errorMessage);

  /// If [value] valid return null othwrise errorMessage.
  String validate(String value) => isValueValid(value) ? null : errorMessage;

  bool isValueValid(String value);
}

/// Predefined value scope validator.
class ScopeParameterValidator extends ParameterValidator {
  final num minValue;
  final num maxValue;

  const ScopeParameterValidator(this.minValue, this.maxValue)
      : super('Allowed value between $minValue and $maxValue.');

  @override
  bool isValueValid(String strValue) {
    num numValue = double.parse(strValue);
    return minValue <= numValue && numValue <= maxValue;
  }
}

class IntTypeValidator extends ParameterValidator {
  const IntTypeValidator() : super('Expected integer value.');

  @override
  bool isValueValid(String strValue) {
    return strValue != null ? int.tryParse(strValue) != null : false;
  }
}

class BoolTypeValidator extends ParameterValidator {
  const BoolTypeValidator() : super('Expected bool value.');

  @override
  bool isValueValid(String strValue) => true;
}

/// The class load, keep and store application parameters.
class Configuration {
  static const String paramPuzzlesCount = 'session.puzzlesCount';
  static const int defaultValuePuzzlesCount = 20;

  final Map<String, Parameter> _parameters = {};

  Configuration._internal() {
    _parameters[paramPuzzlesCount] = Parameter(defaultValuePuzzlesCount,
        ParameterDefinition(paramPuzzlesCount, defaultValuePuzzlesCount));

    for (var gen in PuzzleGeneratorManager().generators) {
      var paramDefs = _readParameterDefinitions(gen);
      paramDefs.forEach((paramDef) => _parameters[paramDef.name] =
          Parameter(paramDef.defaultValue, paramDef));
    }
  }

  static Future<Configuration> load() async {
    var prefs = await SharedPreferences.getInstance();
    var config = Configuration._internal();

    // Load into configuration parameters from SharedPreferences
    var parameters = config.parameters;
    prefs.getKeys().forEach((k) => config.setParameterValue(k, prefs.get(k)));

    // Load into configuration default generator parameters if not already
    // loaded from SharedPreferences
    PuzzleGeneratorManager().generators.forEach((generator) {
      var defParams = _readDefaultParameterValues(generator);
      defParams.forEach((name, value) {
        if (!parameters.containsKey(name)) {
          config.setParameterValue(name, value);
        }
      });
    });

    return config;
  }

  void store() async {
    var prefs = await SharedPreferences.getInstance();
    _parameters.forEach((name, param) {
      dynamic value = param.value;
      if (value is int) {
        prefs.setInt(name, value);
      } else if (value is double) {
        prefs.setDouble(name, value);
      } else if (value is bool) {
        prefs.setBool(name, value);
      } else if (value is String) {
        prefs.setString(name, value);
      } else {
        throw Exception(
            'Parameter of name $name has unsupported type ${value?.runtimeType}.');
      }
    });
  }

  Map<String, Parameter> get parameters => Map.unmodifiable(_parameters);

  void setParameterValue(String name, dynamic value) {
    if (_parameters.containsKey(name)) {
      var parameter = _parameters[name];
      _parameters[name] = Parameter(value, parameter.definition);
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
    var defaultValues = {};
    for (var definition in _readMetadata(generator)) {
      if (definition is ParameterDefinition) {
        defaultValues[definition.name] = definition.defaultValue;
      }
    }
    return Map.unmodifiable(defaultValues);
  }

  static List<ParameterDefinition> _readParameterDefinitions(
      PuzzleGenerator generator) {
    var definitions = [];
    for (var obj in _readMetadata(generator)) {
      if (obj is ParameterDefinition) {
        definitions.add(obj);
      }
    }
    return List.unmodifiable(definitions);
  }
}
