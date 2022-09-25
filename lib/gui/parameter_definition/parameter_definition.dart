import 'package:math_puzzles/gui/parameter_definition/parameter_validators.dart';

import 'parameter_converters.dart';

abstract class ParameterDefinition {
  final String name;

  const ParameterDefinition(this.name);
}

class GroupParameterDefinition extends ParameterDefinition {
  final List<ValueParameterDefinition> children;
  const GroupParameterDefinition(String name, this.children) : super(name);
}

class ValueParameterDefinition<T extends Object> extends ParameterDefinition {
  final ValueConverter<T> converter;
  final List<ParameterValidator<T>> validators;

  const ValueParameterDefinition(String name, this.converter, {this.validators = const []}) : super(name);

  /// If returns null, conversion from string failed.
  T? convertValue(String strValue) => converter.convertValue(strValue);

  Type getExpectedType() => T.runtimeType;

  ParametrizedMessage? validateValue(T? value) {
    var parametrizedMsg;
    if (value == null) {
      var expectedType = getExpectedType();
      if (expectedType == int) {
        parametrizedMsg = ParametrizedMessage('intTypeValidator');
      } else if (expectedType == bool) {
        parametrizedMsg = ParametrizedMessage('boolTypeValidator');
      } else {
        throw UnsupportedError('Parameter of type $expectedType not supported.');
      }
    } else {
      for (var v in validators) {
        parametrizedMsg = v.validate(value);
        if (parametrizedMsg != null) {
          break;
        }
      }
    }
    return parametrizedMsg;
  }
}