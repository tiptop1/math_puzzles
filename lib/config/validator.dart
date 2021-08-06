import 'package:math_puzzles/puzzle_generator.dart';

/// Validation message returned by ParameterValidator for further message
/// translation.
class ParametrizedMessage {
  final String message;
  final List<dynamic> parameters;

  const ParametrizedMessage(this.message, {this.parameters = const []});
}

/// Configuration parameter validator.
/// It assume that parameter will be provided as String - it's because input
/// parameters are entered as text.
abstract class ParameterValidator<T> {
  const ParameterValidator();

  /// If [value] valid return null otherwise errorMessage.
  ParametrizedMessage? validate(T value, Map<String, dynamic> parameterValues);
}

/// Predefined value scope validator.
class IntParameterScopeValidator extends ParameterValidator<int> {
  static const String name = 'numParameterScopeValidator';

  final int minValue;
  final int maxValue;

  const IntParameterScopeValidator(this.minValue, this.maxValue);

  @override
  ParametrizedMessage? validate(int value, Map<String, dynamic> parameterValues) {
    var msg;
    if (value < minValue || value > maxValue) {
      msg = ParametrizedMessage(name, parameters: [minValue, maxValue]);
    }
    return msg;
  }
}

class GeneratorDisableValidator extends ParameterValidator<bool> {
  static const name = 'generatorDisableValidator';

  const GeneratorDisableValidator();

  @override
  ParametrizedMessage? validate(bool value, Map<String, dynamic> parameterValues) {
    var msg;

    if (!value) {
      var enabledCount = 0;
      for (var e in parameterValues.entries) {
        if (e.key.endsWith(PuzzleGenerator.paramEnabledPostfix) && e.value) {
          enabledCount++;
        }
      }
      msg = enabledCount < 2 ? ParametrizedMessage(name) : null;
    }
    return msg;
  }
}

/// Convert type [F] to [T].
abstract class ValueConverter<F, T> {
  const ValueConverter();

  ParametrizedMessage? checkConversionPossibility(F value);

  T convert(F value);
}

class StringToIntConverter extends ValueConverter<String, int> {
  const StringToIntConverter();

  @override
  ParametrizedMessage? checkConversionPossibility(String strValue) =>
      int.tryParse(strValue) == null
          ? ParametrizedMessage('intTypeValidator')
          : null;

  @override
  int convert(String strValue) => int.parse(strValue);
}
