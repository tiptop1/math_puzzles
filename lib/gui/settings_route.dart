import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../configuration.dart';

class SettingsRoute extends StatefulWidget {
  final Configuration _configuration;

  SettingsRoute(this._configuration);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final Map<String, TextEditingController> _editingControlers = {};
  final Map<String, String> _errorMessages = {};

  @override
  void dispose() {
    _editingControlers.forEach((key, value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: _createBody(widget._configuration.parameters));
  }

  Widget _createBody(Map<String, Parameter> parameters) {
    return GridView.count(
      crossAxisCount: 2,
      children: _createGridViewChildren(context, parameters),
    );
  }

  List<Widget> _createGridViewChildren(
      BuildContext context, Map<String, Parameter> parameters) {
    var childWidgets = <Widget>[];
    for (var name in parameters.keys) {
      // Add parameter name
      childWidgets.add(Text(name));
      // Add input widget
      childWidgets.add(_createInputWidget(context, parameters[name]));
    }
    return childWidgets;
  }

  Widget _createInputWidget(BuildContext context, Parameter parameter) {
    Widget inputWidget;
    var value = parameter.value;
    var name = parameter.definition.name;
    if (value is bool) {
      inputWidget = DropdownButton(
        value: value,
        items: [false, true]
            .map<DropdownMenuItem<bool>>(
              (v) =>
                  DropdownMenuItem<bool>(value: v, child: Text(v.toString())),
            )
            .toList(),
        onChanged: (v) =>
            setState(() => widget._configuration.setParameterValue(name, v)),
      );
    } else {
      var defaultValue = parameter.definition.defaultValue;
      // TODO: Add validation
      inputWidget = TextField(
        keyboardType:
            (defaultValue is num ? TextInputType.number : TextInputType.text),
        controller: getEditingControler(name, value.toString()),
        decoration: InputDecoration(
          labelText: '?',
          errorText: _errorMessages[name],
        ),
        onChanged: (v) {
          var errorMsg = _validate(v, parameter.definition.validators);
          setState(() {
            _errorMessages[name] = errorMsg;
            if (errorMsg == null) {
              widget._configuration
                  .setParameterValue(name, _toProperType(v, defaultValue));
            }
          });
        },
      );
    }
    return inputWidget;
  }

  TextEditingController getEditingControler(String name, String initialValue) {
    TextEditingController controller;
    if (_editingControlers.containsKey(name)) {
      controller = _editingControlers[name];
    } else {
      controller = TextEditingController(text: initialValue);
      _editingControlers[name] = controller;
    }
    return controller;
  }

  dynamic _toProperType(String value, dynamic referenceType) {
    dynamic typedValue;
    if (value != null) {
      if (referenceType is int) {
        typedValue = int.parse(value);
      } else if (referenceType is double) {
        typedValue = double.parse(value);
      } else if (referenceType is bool) {
        typedValue = (value.toLowerCase() == 'true');
      } else if (referenceType is String) {
        typedValue = value;
      } else {
        throw Exception(
            'Not supported type ${referenceType?.runtimeType?.toString()}.');
      }
    }
    return typedValue;
  }

  String _validate(String value, List<ParameterValidator> validators) {
    var errorMsg;
    for (var v in validators) {
      var msg = v.validate(value);
      if (msg != null && msg.isNotEmpty) {
        if (errorMsg == null) {
          errorMsg = msg;
        } else {
          errorMsg += ' $msg';
        }
        break;
      }
    }
    return errorMsg;
  }
}
