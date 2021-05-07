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
  ParametrizedMessage? validate(T value);
}

/// Predefined value scope validator.
class IntParameterScopeValidator extends ParameterValidator<int> {
  static const String name = 'numParameterScopeValidator';

  final int minValue;
  final int maxValue;

  const IntParameterScopeValidator(this.minValue, this.maxValue);

  @override
  ParametrizedMessage? validate(int value) {
    var msg;
    if (value < minValue || value > maxValue) {
      msg = ParametrizedMessage(name, parameters: [minValue, maxValue]);
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
