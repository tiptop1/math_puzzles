import 'package:math_puzzles/utils/puzzle_generator.dart';

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
class NumParameterScopeValidator extends ParameterValidator<num> {
  static const String name = 'numParameterScopeValidator';

  final num minValue;
  final num maxValue;

  const NumParameterScopeValidator(this.minValue, this.maxValue);

  @override
  ParametrizedMessage? validate(num value) =>
      (value < minValue || value > maxValue)
          ? ParametrizedMessage(name, parameters: [minValue, maxValue])
          : null;
}


