import 'package:shared_preferences/shared_preferences.dart';

class Configuration {
  static const sessionsPuzzlesCountParam = 'sessions.0.puzzlesCount.0';

  static const additionGeneratorEnabledParam = 'additionGenerator.0.enabled.0';
  static const additionGeneratorMaxResultParam = 'additionGenerator.0.maxResult.1';
  static const additionGeneratorFractionDigits = 'additionGenerator.0.fractionDigits.2';

  static const Map<String, Object> defaultParameters = {
    sessionsPuzzlesCountParam: 20,

    'additionGenerator.enabled': true,
    'additionGenerator.maxResult': 100,
    'additionGenerator.fractionDigits': 2,

    'subtractionGenerator.enabled': true,
    'subtractionGenerator.maxResult': 100,
    'subtractionGenerator.fractionDigits': 2,

    'multiplicationTableGenerator.enabled': true,
    'multiplicationTableGenerator.multiplicationTimes': 10,

    'divisionGenerator.enabled': true,
    'divisionGenerator.maxResult': 100,

    'percentageGenerator.enabled': true,
    'percentageGenerator.maxResult': 100,
    'percentageGenerator.fractionDigits': 2,
  };

  final Map<String, Object> _parameters;

  Configuration._internal(this._parameters);

  static Future<Configuration> load() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var parameters = <String, Object>{};
    for (var name in defaultParameters.keys) {
      var defaultValue = defaultParameters[name];
      var storedValue = sharedPrefs.get(name);
      parameters[name] = (storedValue == null || storedValue.runtimeType != defaultValue.runtimeType) ? defaultValue! : storedValue!;
    }
    return Configuration._internal(parameters);
  }

  Map<String, Object> get parameters => Map.unmodifiable(_parameters);

  void removeParameter(String name) => _parameters.remove(name);

  void putParameter(String name, Object value) {
    if (isTypeSupported(value)) {
      _parameters[name] = value;
    } else {
      throw UnsupportedError(
          'Putting parameter "$name" with value of type ${value.runtimeType} is not supported.');
    }
  }

  Future<void> store() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var names = _parameters.keys.toSet();

    sharedPrefs
        .getKeys()
        .difference(names)
        .forEach((k) => sharedPrefs.remove(k));

    for (var name in names) {
      var value = _parameters[name];
      if (value is bool) {
        await sharedPrefs.setBool(name, value);
      } else if (value is double) {
        await sharedPrefs.setDouble(name, value);
      } else if (value is int) {
        await sharedPrefs.setInt(name, value);
      } else if (value is String) {
        await sharedPrefs.setString(name, value);
      } else {
        throw UnsupportedError(
            'Storing parameter "$name" with value of type ${value.runtimeType} is not supported.');
      }
    }
  }

  bool isTypeSupported(Object value) =>
      value is bool || value is int || value is double || value is String;
}
