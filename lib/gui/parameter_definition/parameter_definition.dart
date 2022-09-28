import 'package:flutter/material.dart';
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

  const ValueParameterDefinition(String name, this.converter,
      {this.validators = const []})
      : super(name);

  /// If returns null, conversion from string failed.
  T? convertValue(String? strValue) => converter.convertValue(strValue);

  Type getExpectedType() => T.runtimeType;

  String? validateValue(BuildContext context, T value) {
    var validationMsg;
    for (var v in validators) {
      validationMsg = v.validate(context, value);
      if (validationMsg != null) {
        break;
      }
    }
    return validationMsg;
  }
}
