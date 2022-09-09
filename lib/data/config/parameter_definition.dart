import 'package:math_puzzles/data/config/parameter_validators.dart';

import 'parameter_converters.dart';

class ParameterDefinition<T> {
  final String name;
  final int order;

  const ParameterDefinition(this.name, {this.order = 0});
}

class GroupParameterDefinition extends ParameterDefinition {
  final List<ScalarParameterDefinition> children;

  const GroupParameterDefinition(String name, this.children, {int order = 0})
      : super(name, order: order);
}

abstract class ScalarParameterDefinition<T> extends ParameterDefinition {
  final List<ParameterValidator<T>> validators;
  final ValueConverter converter;

  const ScalarParameterDefinition(String name, this.converter, {int order = 0, this.validators = const []}) : super(name, order: order);

  ParametrizedMessage? validate(T value) {
    ParametrizedMessage? msg;
    for (var v in validators) {
      msg = v.validate(value);
      if (msg != null) {
        break;
      }
    }
    return msg;
  }

  ParametrizedMessage? checkConversion(dynamic value);

  T convert(dynamic value);
}