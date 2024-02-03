import 'dart:async';

import 'package:get_it/get_it.dart';

import '../data/config/configuration.dart';
import 'bloc.dart';

class SettingsBloc extends Bloc {
  static final Configuration _configuration = GetIt.I.get<Configuration>();
  final StreamController<Map<String, Object>> _controller =
      _initController(_configuration);
  late final Stream<Map<String, Object>> stream;

  SettingsBloc() {
    stream = _controller.stream;
  }

  @override
  void dispose() {
    // TODO: HACK - it seems that dispose function parameter in GetIt.I.registerSingletonAsync doesn't work
    _configuration.store();
    _controller.close();
  }

  void setParameterValue(String name, Object value) {
    var params = _configuration.parameters;
    if (params.containsKey(name)) {
      // TODO: Temporary protection against disabling all generators
      if (!name.endsWith('Enabled')
          || (name.endsWith('Enabled') && value == true)
          || (name.endsWith('Enabled') && value == false && params.entries.where((e) => e.key.endsWith('Enabled') && e.value == true).length > 1)) {
        // TODO: Protect Configuration against put parameters without notification the BLoC.
        _configuration.putParameter(name, value);
        _controller.sink.add(_configuration.parameters);
      }
    } else {
      throw UnsupportedError(
          'Parameter "$name" is not supported - could not set its value.');
    }
  }

  static StreamController<Map<String, Object>> _initController(
      Configuration configuration) {
    var controller = StreamController<Map<String, Object>>();
    controller.add(configuration.parameters);
    return controller;
  }
}
