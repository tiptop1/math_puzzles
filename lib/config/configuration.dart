import 'package:math_puzzles/config/parameter.dart';
import 'package:math_puzzles/config/validator.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class load, keep and store application parameters.
class Configuration {
  static const String parameterGroupSep = '.';

  static const String sessionParamGroup = 'session';
  static const String puzzlesCountParam = 'puzzlesCount';
  static const int defaultValuePuzzlesCount = 20;

  static final List<ParameterDefinition> _parameterDefinitions = _createParameterDefinitions();

  final Map<String, dynamic> _parameters = {};

  Configuration._internal();

  static Future<Configuration> load() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var config = Configuration._internal();

    // Default values for all parameters
    var defaultValues = _readDefaultValues(_parameterDefinitions);

    // Load into configuration parameters from SharedPreferences,
    // but only parameters containing definition. If parameter doesn't have
    // definition remove it from shared preferences
    for (var k in sharedPrefs.getKeys()) {
      if (defaultValues.containsKey(k)) {
        var value = sharedPrefs.get(k);
        // Check value of loaded parameter - if not valid, set default value.
        var paramDef = findParameterDefinition(k);
        if (paramDef is ScalarParameterDefinition && paramDef.checkConversion(value) == null && paramDef.validate(value) == null) {
          config._parameters[k] = sharedPrefs.get(k);
        } else {
          config._parameters[k] = defaultValues[k];
        }
      } else {
        unawaited(sharedPrefs.remove(k));
      }
    }

    // Add default values for parameters not loaded yet
    for (var k in defaultValues.keys) {
      if (!config._parameters.containsKey(k)) {
        config._parameters[k] = defaultValues[k];
      }
    }

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
            'Parameter of name $name has unsupported type ${value
                ?.runtimeType}.');
      }
    });
  }

  Map<String, dynamic> get parameters => Map.unmodifiable(_parameters);

  List<ParameterDefinition> get parameterDefinitions =>
      List.unmodifiable(_parameterDefinitions);

  /// Set known (having definition) parameter [name] [value].
  void setParameterValue(String name, dynamic value) {
    var def = findParameterDefinition(name);
    if (def != null) {

      _parameters[name] = value;
    } else {
      throw Exception('Definition for parameter \'$name\' unknown.');
    }
  }

  static ParameterDefinition findParameterDefinition(String parameterName) {
    throw UnimplementedError('The method not implemented yet!');
  }

  static List<Object> _readMetadata(PuzzleGenerator generator) {
    var typeMirror = metadataReflector.reflectType(generator.runtimeType);
    return typeMirror.metadata;
  }

  static Map<String, dynamic> _readDefaultValues(
      List<ParameterDefinition> parameterDefinitions) {
    var defaultValues = {};
    parameterDefinitions.forEach((def) =>
        _collectDefaultValues('', def, defaultValues));
    return Map.unmodifiable(defaultValues);
  }

  /// Recurrent method to find all default values of [paramDef] parameter definition.
  static void _collectDefaultValues(String parentParamName,
      ParameterDefinition paramDef, Map<String, dynamic> defaultVal) {
    if (paramDef is GroupParameterDefinition) {
      paramDef.children.forEach((child) =>
          _collectDefaultValues('${paramDef.name}.', child, defaultVal));
    } else if (paramDef is ScalarParameterDefinition) {
      defaultVal['$parentParamName$parameterGroupSep${paramDef.name}'] =
          paramDef.defaultValue;
    } else {
      throw Exception('Not supported type ${paramDef.runtimeType
          .toString()} of parameter definition.');
    }
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

  static List<ParameterDefinition> _createParameterDefinitions() {
    var parameterDefinitions = [];

    // Add some default parameter definitions
    var sessionParameterGroup = GroupParameterDefinition(sessionParamGroup, [
      IntegerParameterDefinition(
        puzzlesCountParam, defaultValuePuzzlesCount, validators: [
        NumParameterScopeValidator(1, 1000),
      ],),
    ], order: 100,);

    parameterDefinitions.add(sessionParameterGroup);

    // Get parameter definitions from puzzle generators
    for (var gen in PuzzleGeneratorManager().generators) {
      var paramDefs = _readParameterDefinitions(gen);
      paramDefs.forEach((paramDef) => parameterDefinitions.add(paramDef));
    }

    return List.unmodifiable(parameterDefinitions);
  }


}
