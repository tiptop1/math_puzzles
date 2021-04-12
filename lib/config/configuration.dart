import 'package:math_puzzles/config/parameter.dart';
import 'package:math_puzzles/config/validator.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class load, keep and store application parameters.
class Configuration {
  static const String groupSeparator = '.';

  static const String sessionParamGroup = 'session';
  static const String puzzlesCountParam = '$sessionParamGroup${groupSeparator}puzzlesCount';
  static const int defaultValuePuzzlesCount = 20;

  static final List<ParameterDefinition> _parameterDefinitions =
      _createParameterDefinitions();

  final Map<String, dynamic> _parameterValues = {};

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
        if (paramDef is ScalarParameterDefinition &&
            paramDef.checkConversion(value) == null &&
            paramDef.validate(value) == null) {
          config._parameterValues[k] = sharedPrefs.get(k);
        } else {
          config._parameterValues[k] = defaultValues[k];
        }
      } else {
        unawaited(sharedPrefs.remove(k));
      }
    }

    // Add default values for parameters not loaded yet
    for (var k in defaultValues.keys) {
      if (!config._parameterValues.containsKey(k)) {
        config._parameterValues[k] = defaultValues[k];
      }
    }

    return config;
  }

  void store() async {
    var prefs = await SharedPreferences.getInstance();
    _parameterValues.forEach((name, param) {
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

  Map<String, dynamic> get parameterValues => Map.unmodifiable(_parameterValues);

  List<ParameterDefinition> get parameterDefinitions =>
      List.unmodifiable(_parameterDefinitions);

  /// Set known (having definition) parameter [name] [value].
  void setParameterValue(String name, dynamic value) {
    var def = findParameterDefinition(name);
    if (def != null) {
      if (def is ScalarParameterDefinition) {
        if (def.checkConversion(value) == null) {
          var convertedValue = def.convert(value);
          if (def.validate(convertedValue) == null) {
            _parameterValues[name] = convertedValue;
          } else {
            throw Exception("Parameter '$name' has not valid value.");
          }
        } else {
          throw Exception(
              "Definition for parameter '$name' allow other value type.");
        }
      } else {
        throw Exception("Parameter '$name' is not scalar value.");
      }
    } else {
      throw Exception("Definition for parameter '$name' unknown.");
    }
  }

  static ParameterDefinition findParameterDefinition(String name) {
    ParameterDefinition paramDef;
    var groupName = groupParameterName(name);
    if (groupName == null) {
      paramDef = _parameterDefinitions.firstWhere((d) => d.name == name);
    } else {
      var groupParameterDefinition =
          _parameterDefinitions.firstWhere((d) => d.name == groupName, orElse: ()=> null);
      if (groupParameterDefinition is GroupParameterDefinition) {
        paramDef = groupParameterDefinition.children
            .firstWhere((d) => d.name == childParameterName(name));
      }
    }
    return paramDef;
  }

  static String groupParameterName(String name) {
    String group;
    var index = name.indexOf(groupSeparator);
    if (index > -1) {
      group = name.substring(0, index);
    }
    return group;
  }

  static String childParameterName(String name) {
    String child;
    var index = name.indexOf(groupSeparator);
    if (index > -1) {
      child = name.substring(index + 1);
    } else {
      child = name;
    }
    return child;
  }

  static List<Object> _readMetadata(PuzzleGenerator generator) {
    var typeMirror = metadataReflector.reflectType(generator.runtimeType);
    return typeMirror.metadata;
  }

  static Map<String, dynamic> _readDefaultValues(
      List<ParameterDefinition> parameterDefinitions) {
    var defaultValues = {};
    for (var def in parameterDefinitions) {
      if (def is ScalarParameterDefinition) {
        defaultValues[def.name] = def.defaultValue;
      } else if (def is GroupParameterDefinition) {
        def.children.forEach((d) =>
            defaultValues[d.name] = d.defaultValue);
      } else {
        throw Exception(
            "Unsupported parameter definition of type ${def.runtimeType.toString()} for parameter name '${def.name}'.");
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

  static List<ParameterDefinition> _createParameterDefinitions() {
    var parameterDefinitions = [];

    // Add some default parameter definitions
    var sessionGroupParameterDefinition = GroupParameterDefinition(
      sessionParamGroup,
      [
        IntParameterDefinition(
          puzzlesCountParam,
          defaultValuePuzzlesCount,
          validators: [
            IntParameterScopeValidator(1, 1000),
          ],
        ),
      ],
      order: 100,
    );

    parameterDefinitions.add(sessionGroupParameterDefinition);

    // Get parameter definitions from puzzle generators
    for (var gen in PuzzleGeneratorManager().generators) {
      var paramDefs = _readParameterDefinitions(gen);
      paramDefs.forEach((paramDef) => parameterDefinitions.add(paramDef));
    }

    return List.unmodifiable(parameterDefinitions);
  }
}
