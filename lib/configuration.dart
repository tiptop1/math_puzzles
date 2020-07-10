import 'dart:math';

import 'package:math_puzzles/puzzle_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class load, keep and store application parameters
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
      Map<String, dynamic> defParams = generator.defaultParameters;
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
}
