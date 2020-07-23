import 'package:math_puzzles/puzzle_generator.dart';
import 'package:reflectable/reflectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class could be used as annotation to define default configuration parameters.
class ParameterDefinition {
  final String name;
  final dynamic defaultValue;
  final List validators;

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

/// The class load, keep and store application parameters.
class Configuration {
  Map<String, dynamic> parameters = {};

  Configuration._internal();

  static Future<Configuration> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Configuration config = Configuration._internal();

    // Load into configuration parameters from SharedPreferences
    Map<String, dynamic> configParams = config.parameters;
    prefs.getKeys().forEach((k) => configParams[k] = prefs.get(k));

    // Load into configuration default generator parameters if not already
    // loaded from SharedPreferences
    PuzzleGeneratorManager.generators.forEach((generator) {
      Map<String, dynamic> defParams = readDefaultParameters(generator);
      defParams.forEach((key, value) {
        if (!configParams.containsKey(key)) {
          configParams[key] = value;
        }
      });
    });

    return config;
  }

  void store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parameters.forEach((k, v) {
      if (v is int) {
        prefs.setInt(k, v);
      } else if (v is double) {
        prefs.setDouble(k, v);
      } else if (v is bool) {
        prefs.setBool(k, v);
      } else if (v is String) {
        prefs.setString(k, v);
      } else {
        throw Exception(
            'Value of key $k has unsupported type ${v?.runtimeType}.');
      }
    });
  }

  static Map<String, dynamic> readDefaultParameters(PuzzleGenerator generator) {
    TypeMirror typeMirror = reflector.reflectType(generator.runtimeType);
    List<Object> metadata = typeMirror.metadata;
    Map<String, dynamic> defaultParams = {};
    for (Object obj in metadata) {
      if (obj is ParameterDefinition) {
        defaultParams[obj.name] = obj.defaultValue;
      }
    }
    return defaultParams;
  }
}
