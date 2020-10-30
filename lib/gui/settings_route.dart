import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../configuration.dart';

class SettingsRoute extends StatefulWidget {
  final Configuration _configuration;

  SettingsRoute(this._configuration);

  @override
  State createState() {
    return SettingsRouteState();
  }
}

class SettingsRouteState extends State<SettingsRoute> {
  static const String sectionDivider = '.';

  @override
  Widget build(BuildContext context) {
    var groupedParams = _prepareListItems(widget._configuration.parameters);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: ListView.builder(
        itemCount: groupedParams.length,
        itemBuilder: (context, i) => _listItemBuilder(
            context, i, groupedParams, widget._configuration.parameters),
      ),
    );
  }

  /// List items contains: parameters, strings for headline
  /// and nulls for dividers.
  List<dynamic> _prepareListItems(Map<String, Parameter> parameters) {
    // Divide parameters by sections
    var groupedParams = <String, List<Parameter>>{};
    for (var paramName in parameters.keys.toList()..sort()) {
      var groupName = _extractGroupName(paramName);
      if (groupedParams.containsKey(groupName)) {
        groupedParams[groupName].add(parameters[paramName]);
        groupedParams[groupName].sort((a,b) => a.definition.name.compareTo(b.definition.name));
      } else {
        groupedParams[groupName] = [parameters[paramName]];
      }
    }

    // Flat sections map to list separated with null
    var i = 0;
    var listItems = <dynamic>[];
    for (var s in groupedParams.keys) {
      // Add name of headline
      listItems.add(s);
      // Add parameters
      listItems.addAll(groupedParams[s]);
      if (i < groupedParams.length - 1) {
        // Add parameters group separator
        listItems.add(null);
      }
      i++;
    }
    return listItems;
  }

  // Extracts group name from parameter name [paramName]
  String _extractGroupName(String paramName) {
    var tokens = paramName?.split(sectionDivider);
    var groupName;
    if (tokens != null && tokens.length > 1) {
      groupName = tokens[0];
    }
    return groupName;
  }

  Widget _listItemBuilder(BuildContext context, int i, List<dynamic> listItems,
      Map<String, Parameter> parameters) {
    assert(i < listItems.length,
        'Try to create list item with index $i, but there are ${listItems.length} items.');
    var listItem = listItems[i];
    var listItemWidget;
    if (listItem is Parameter) {
      listItemWidget = _createListItemForParameter(listItem);
    } else if (listItem is String) {
      listItemWidget = _createListItemForHeadline(listItem);
    } else {
      listItemWidget = Divider();
    }
    return listItemWidget;
  }

  Widget _createListItemForParameter(Parameter parameter) {
    return ListTile(
      title: Text('${parameter.definition.name}: ${parameter.value}'),
    );
  }

  Widget _createListItemForHeadline(String headline) {
    return ListTile(title: Text(headline));
  }
}
