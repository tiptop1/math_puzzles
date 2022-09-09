import 'package:flutter/material.dart';
import 'package:math_puzzles/generated/l10n.dart';

import '../data/config/configuration.dart';
import '../data/config/parameter.dart';
import '../data/config/validator.dart';

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
    var flattenParamDefs = _flattenParameterDefinitions(
        widget._configuration.parameterDefinitions);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(AppLocalizations.of(context).settingsMenu),
      ),
      body: ListView.builder(
        itemCount: flattenParamDefs.length,
        itemBuilder: (context, i) => _listItemBuilder(context, i,
            flattenParamDefs, widget._configuration.parameterValues),
      ),
    );
  }

  /// List items contains: parameters, strings for headline
  /// and nulls for dividers.
  List<ParameterDefinition?> _flattenParameterDefinitions(
      List<ParameterDefinition> paramDefinitions) {
    var sortedParamDefs =
        List<ParameterDefinition?>.filled(paramDefinitions.length, null);
    List.copyRange(sortedParamDefs, 0, paramDefinitions);
    sortedParamDefs.sort((a, b) => a!.order - b!.order);

    var flattenParamDefs = <ParameterDefinition?>[];
    for (var paramDef in sortedParamDefs) {
      if (flattenParamDefs.isNotEmpty) {
        flattenParamDefs.add(null);
      }
      flattenParamDefs.add(paramDef);
      if (paramDef is GroupParameterDefinition) {
        var sortedChildren =
            List<ParameterDefinition?>.filled(paramDef.children.length, null);
        List.copyRange(sortedChildren, 0, paramDef.children);
        sortedChildren.sort((a, b) => a!.order - b!.order);
        flattenParamDefs.addAll(sortedChildren);
      }
    }
    return flattenParamDefs;
  }

  Widget _listItemBuilder(
      BuildContext context,
      int i,
      List<ParameterDefinition?> flattenParamDefinitions,
      Map<String, dynamic> paramValues) {
    var paramDef = flattenParamDefinitions[i];
    var listItemWidget;
    if (paramDef is ScalarParameterDefinition) {
      listItemWidget = _createScalarParameterDefinitionItem(
          context, paramDef, paramValues[paramDef.name]);
    } else if (paramDef is GroupParameterDefinition) {
      listItemWidget = _createGroupParameterDefinitionItem(context, paramDef);
    } else {
      listItemWidget = Divider(color: Colors.black, thickness: 2);
    }
    return listItemWidget;
  }

  Widget _createScalarParameterDefinitionItem(BuildContext context,
      ScalarParameterDefinition paramDefinition, dynamic paramValue) {
    return ListTile(
      title: Text(
          '${dynamicMessage(context, paramDefinition.name)}: ${_translate(context, paramValue)}'),
      onTap: () {
        _showEditParameterDialog(paramDefinition, paramValue)
            .then((newParamValue) {
          if (newParamValue != null && newParamValue != paramValue) {
            setState(() {
              widget._configuration
                  .setParameterValue(paramDefinition.name, newParamValue);
            });
          }
        });
      },
    );
  }

  Widget _createGroupParameterDefinitionItem(
      BuildContext context, GroupParameterDefinition paramDef) {
    return ListTile(
      title: Text(
        dynamicMessage(context, paramDef.name),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<dynamic> _showEditParameterDialog(
      ScalarParameterDefinition paramDef, dynamic paramValue) async {
    var dialogChildren;
    if (paramValue is bool) {
      dialogChildren = [
        BoolRadioButtonGroup(paramDef, paramValue, widget._configuration)
      ];
    } else if (paramValue is int) {
      dialogChildren = [
        IntInputField(paramDef, paramValue, widget._configuration)
      ];
    } else {
      throw UnsupportedError('Dialogs not supported for parameter of type '
          '${paramValue?.runtimeType}.');
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
          title: Text(dynamicMessage(context, paramDef.name)),
          children: dialogChildren),
    );
  }

  String _translate(BuildContext context, dynamic paramValue) {
    var translatedValue;
    if (paramValue is bool) {
      var appLoc = AppLocalizations.of(context);
      translatedValue = (paramValue ? appLoc.boolTrue : appLoc.boolFalse);
    } else if (paramValue is String) {
      translatedValue = dynamicMessage(context, paramValue);
    } else {
      translatedValue = paramValue?.toString();
    }
    return translatedValue;
  }
}

class BoolRadioButtonGroup extends StatefulWidget {
  final ScalarParameterDefinition _paramDef;
  final bool _paramValue;
  final Configuration _configuration;

  BoolRadioButtonGroup(this._paramDef, this._paramValue, this._configuration);

  @override
  State createState() => _BoolRadioButtonGroupState();
}

class _BoolRadioButtonGroupState extends State<BoolRadioButtonGroup> {
  bool _groupValue = false;
  ParametrizedMessage? _newValueValidationMsg;

  _BoolRadioButtonGroupState();

  @override
  void initState() {
    super.initState();
    _groupValue = widget._paramValue;
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      ListTile(
        title: Text(AppLocalizations.of(context).boolTrue),
        leading: Radio(
          value: true,
          groupValue: _groupValue,
          onChanged: onChangeHandler,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).boolFalse),
        leading: Radio(
          value: false,
          groupValue: _groupValue,
          onChanged: onChangeHandler,
        ),
      ),
    ];

    var divider;
    var text;

    if (_newValueValidationMsg != null) {
      var theme = Theme.of(context);
      divider = Divider(
        color: theme.errorColor,
        thickness: 1.0,
      );
      text = Text(
          dynamicMessage(context, _newValueValidationMsg!.message,
              args: _newValueValidationMsg!.parameters),
          style: theme.textTheme.overline!.apply(color: theme.errorColor));
    } else {
      divider = Divider(
        color: Colors.grey,
        thickness: 1.0,
      );
    }

    widgets.add(divider);
    if (text != null) {
      widgets.add(text);
    }

    return Column(children: widgets);
  }

  void onChangeHandler(bool? newValue) {
    _newValueValidationMsg = widget._paramDef
        .validate(newValue, widget._configuration.parameterValues);
    setState(() => _groupValue = (newValue ?? false));
    if (_newValueValidationMsg == null) {
      Navigator.pop(context, _groupValue);
    }
  }
}

class IntInputField extends StatefulWidget {
  final ScalarParameterDefinition _paramDef;
  final dynamic _paramValue;
  final Configuration _configuration;

  IntInputField(this._paramDef, this._paramValue, this._configuration);

  @override
  State createState() => _IntInputFieldState();
}

class _IntInputFieldState extends State<IntInputField> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget._paramValue.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget._paramValue.toString();
    var paramDef = widget._paramDef;
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: true),
        validator: (value) {
          var parametrizedMsg = paramDef.checkConversion(value);
          parametrizedMsg ??= paramDef.validate(
              paramDef.convert(value), widget._configuration.parameterValues);
          return parametrizedMsg != null
              ? dynamicMessage(context, parametrizedMsg.message,
                  args: parametrizedMsg.parameters)
              : null;
        },
        onEditingComplete: () {
          var formState = _formKey.currentState;
          if (formState != null && formState.validate()) {
            Navigator.pop(context, paramDef.convert(_controller.text));
          }
        },
      ),
    );
  }
}

String dynamicMessage(BuildContext context, String name,
    {List<dynamic> args = const []}) {
  var instanceMirror = invokingReflector.reflect(AppLocalizations.of(context));
  var classMirror = instanceMirror.type;

  // First of all check if requested method exists
  var methodMirror;
  var instanceMembers = classMirror.instanceMembers;
  var methodName = name.replaceAll('\.', '_');
  for (var memberName in instanceMembers.keys) {
    if (memberName == methodName) {
      methodMirror = instanceMembers[memberName];
      break;
    }
  }

  var message;
  if (methodMirror != null) {
    // If method exists - call it
    message = (args.isEmpty
        ? instanceMirror.invokeGetter(methodName)
        : instanceMirror.invoke(methodName, args));
  } else {
    message = '#$name#';
  }
  return message;
}
