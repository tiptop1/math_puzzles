import 'dart:math';

import 'package:math_puzzles/puzzle_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The class load, keep and store application parameters
class Configuration {
  static Configuration _instance = Configuration._internal();

  Map<String, Object> parameters;

  List<PuzzleGenerator> availableGenerators = [
    // TODO: Do something with the Randoms
    DoubleAdditionPuzzleGenerator(new Random()),
    MultiplicationTablePuzzleGenerator(new Random())
  ];

  Configuration._internal() : parameters = {} {
    _initializeWithDefaultParameters();
  }

  static Configuration instance() => _instance;

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((k) => parameters[k] = prefs.get(k));
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

  /// Initializes configuration with default parameters
  void _initializeWithDefaultParameters() {
    availableGenerators.forEach((g) => parameters.addAll(g.defaultParameters));
  }
}
