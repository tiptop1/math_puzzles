import 'package:shared_preferences/shared_preferences.dart';

class Configuration {
  static const sesstionGroup = 'session';
  static const sessionsPuzzlesCountParam = 'sessionsPuzzlesCount';

  static const additionGroup = 'addition';
  static const additionEnabledParam = 'additionEnabled';
  static const additionMaxResultParam = 'additionMaxResult';
  static const additionFractionDigits = 'additionFractionDigits';

  static const subtractionGroup = 'subtraction';
  static const subtractionEnabledParam = 'subtractionEnabled';
  static const subtractionMaxResultParam = 'subtractionMaxResult';
  static const subtractionFractionDigitsParam = 'subtractionFractionDigits';

  static const multiplicationTableGroup = 'multiplicationTable';
  static const multiplicationTableEnabledParam = 'multiplicationTableEnabled';
  static const multiplicationTableMultiplierParam = 'multiplicationTableMultiplier';
  static const multiplicationTableMultiplicandParam = 'multiplicationTableMultiplicand';

  static const divisionGroup = 'division';
  static const divisionEnabledParam = 'divisionGeneratorEnabled';
  static const divisionMaxResultParam = 'divisionGeneratorMaxResult';

  static const percentageGroup = 'percentage';
  static const percentageEnabledParam = 'percentageEnabled';
  static const percentageMaxResultParam = 'percentageMaxResult';
  static const percentageFractionDigitsParam = 'percentageFractionDigits';

  static const Map<String, Object> defaultParameters = {
    sessionsPuzzlesCountParam: 20,
    additionEnabledParam: true,
    additionMaxResultParam: 100,
    additionFractionDigits: 2,
    subtractionEnabledParam: true,
    subtractionMaxResultParam: 100,
    subtractionFractionDigitsParam: 2,
    multiplicationTableEnabledParam: true,
    multiplicationTableMultiplicandParam: 10,
    multiplicationTableMultiplierParam: 10,
    divisionEnabledParam: true,
    divisionMaxResultParam: 100,
    percentageEnabledParam: true,
    percentageMaxResultParam: 100,
    percentageFractionDigitsParam: 2,
  };

  final Map<String, Object> _parameters;

  Configuration._internal(this._parameters);

  static Future<Configuration> load() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var parameters = <String, Object>{};
    for (var name in defaultParameters.keys) {
      var defaultValue = defaultParameters[name];
      var storedValue = sharedPrefs.get(name);
      parameters[name] = (storedValue == null ||
              storedValue.runtimeType != defaultValue.runtimeType)
          ? defaultValue!
          : storedValue;
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
