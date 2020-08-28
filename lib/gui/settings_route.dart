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
    return null;
 }

}
