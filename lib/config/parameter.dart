import 'package:math_puzzles/config/validator.dart';

/// The class could be used as annotation to define default configuration parameters.
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
  final T defaultValue;
  final List<ParameterValidator<T>> validators;

  const ScalarParameterDefinition(String name, this.defaultValue,
      {int order = 0, this.validators = const []}) : super(name, order: order);

  ParametrizedMessage? validate(T value, Map<String, dynamic> parameterValues) {
    ParametrizedMessage? msg;
    if (validators.isNotEmpty) {
      for (var v in validators) {
        msg = v.validate(value, parameterValues);
        if (msg != null) {
          break;
        }
      }
    }
    return msg;
  }

  ParametrizedMessage? checkConversion(dynamic value);

  T convert(dynamic value);
}

class StringParameterDefinition extends ScalarParameterDefinition<String> {
  const StringParameterDefinition(String name, String defaultValue,
      {int order = 0, List<ParameterValidator<String>> validators = const []})
      : super(name, defaultValue, order: order, validators: validators);

  @override
  String convert(dynamic value) => value.toString();

  @override
  ParametrizedMessage? checkConversion(dynamic value) => null;
}

class BoolParameterDefinition extends ScalarParameterDefinition<bool> {
  const BoolParameterDefinition(String name, bool defaultValue,
      {int order = 0, List<ParameterValidator<bool>> validators = const[]})
      : super(name, defaultValue, order: order, validators: validators);

  @override
  bool convert(dynamic value) {
    bool boolValue;
    if (value is bool) {
      boolValue = value;
    } else if (value is String) {
      boolValue = value.toLowerCase() == 'true';
    } else {
      throw Exception('Value ${value as String} could not be converter to bool type.');
    }
    return boolValue;
  }

  @override
  ParametrizedMessage? checkConversion(dynamic value) {
    var msg;
    if (!(value is String) && !(value is bool)) {
      msg = ParametrizedMessage('boolTypeValidator');
    }
    return msg;
  }
}

class IntParameterDefinition extends ScalarParameterDefinition<int> {
  const IntParameterDefinition(String name, int defaultValue,
      {int order = 0, List<ParameterValidator<int>> validators = const []})
      : super(name, defaultValue, order: order, validators: validators);

  @override
  int convert(dynamic value) {
    var intValue;
    if (value is int) {
      intValue = value;
    } else if (value is String) {
      intValue = int.parse(value);
    } else {
      throw Exception('Value ${value.toString()} could not be converter to int type.');
    }
    return intValue;
  }

  @override
  ParametrizedMessage? checkConversion(dynamic value) {
    var msg;
    if ((value is! int && value is! String) || (value is String && int.tryParse(value) == null)) {
      msg = ParametrizedMessage('intTypeValidator');
    }
    return msg;
  }
}