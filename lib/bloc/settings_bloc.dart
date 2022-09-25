import 'dart:async';

import 'package:get_it/get_it.dart';

import '../data/config/configuration.dart';
import '../gui/parameter_definition/parameter_definition.dart';
import '../utils/app_constants.dart';

import 'bloc.dart';

class SettingsBloc extends Bloc {
  static final Configuration _configuration = GetIt.I.get<Configuration>();
  final Map<String, StreamController<Object>> _controllers = _createControllers(_configuration);

  @override
  void dispose() => _controllers.forEach((paramName, controller) => controller.close());

  static Map<String, StreamController<Object>> _createControllers(Configuration config) {
    var controllers = <String, StreamController<Object>>{};
    for (var paramDef in AppConstants.parameterDefinitions) {
      if (paramDef is ValueParameterDefinition) {
        _putStreamController(paramDef.name, config.parameters, controllers);
      } else if (paramDef is GroupParameterDefinition) {
        paramDef.children.forEach((child) => _putStreamController(child.name, config.parameters, controllers));
      } else {
        throw UnsupportedError('Parameter definition of type ${paramDef.runtimeType} is not supported.');
      }
    }
    return controllers;
  }

  static void _putStreamController(String name, Map<String, Object> parameters, Map<String, StreamController<Object>> controllers) {
    if (parameters.containsKey(name)) {
      var controller = StreamController<Object>();
      controller.sink.add(parameters[name]!);
      controllers[name] = controller;
    } else {
      throw UnsupportedError('Parameter "$name" not supported by configuration.');
    }
  }

  Stream<Object> getParametersValueStream(String name) {
    if (_controllers.containsKey(name)) {
      return _controllers[name]!.stream;
    } else {
      throw UnsupportedError('Parameter "$name" not supported by BLoC.');
    }
  }

  void setParameterValue(String name, Object value) {
    var params = _configuration.parameters;
    if (params.containsKey(name)) {
      // TODO: Protect Configuration against put parameters without notification the BLoC.
      _configuration.putParameter(name, value);
      _controllers[name]!.sink.add(value);
    } else {
      throw UnsupportedError('Parameter "$name" is not supported - could not set its value.');
    }
  }

}