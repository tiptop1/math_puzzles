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
      children: _createGridViewChildren(parameters),
    );
  }

  List<Widget> _createGridViewChildren(Map<String, Parameter> parameters) {
    List<Widget> childWidgets = [];
    for (var name in parameters.keys) {
      // Add parameter name
      childWidgets.add(Text(name));
      // Add input widget
      childWidgets.add(_createInputWidget(parameters[name]));
    }
    return childWidgets;
  }

  Widget _createInputWidget(Parameter parameter) {
    Widget inputWidget;
    var value = parameter.value;
    var name = parameter.definition.name;
    if (value is bool) {
      inputWidget = DropdownButton(
        value: value,
        items: [false, true]
            .map<DropdownMenuItem<bool>>(
              (value) =>
              DropdownMenuItem<bool>(
                  value: value, child: Text(value.toString())),
        )
            .toList(),
        onChanged: (value) =>
            setState(() =>
                widget._configuration
                    .setParameterValue(name, value)),
      );
    } else {
      // TODO: Add validation
      inputWidget = TextField(
        controller: getEditingControler(name, value.toString()),
        onSubmitted: (newValue) =>
            setState(() =>
                // TODO: convert newValue to proper type
                widget._configuration.setParameterValue(name, int.parse(newValue))),
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
}
