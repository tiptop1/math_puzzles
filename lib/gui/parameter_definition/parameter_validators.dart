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
  ParametrizedMessage? validate(int value) =>
      (value < minValue || value > maxValue)
          ? ParametrizedMessage(name, parameters: [minValue, maxValue])
          : null;
}


