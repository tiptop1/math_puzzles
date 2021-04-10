import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_puzzles/config/parameter.dart';
import 'package:math_puzzles/config/validator.dart';
import 'package:math_puzzles/localizations.dart';

import '../config/configuration.dart';

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
      appBar: AppBar(automaticallyImplyLeading: true),
      body: ListView.builder(
        itemCount: flattenParamDefs.length,
        itemBuilder: (context, i) => _listItemBuilder(context, i,
            flattenParamDefs, widget._configuration.parameterValues),
      ),
    );
  }

  /// List items contains: parameters, strings for headline
  /// and nulls for dividers.
  List<ParameterDefinition> _flattenParameterDefinitions(
      List<ParameterDefinition> paramDefinitions) {
    var defs = [] as List<ParameterDefinition>;
    for (var paramDef in paramDefinitions) {
      if (defs.isNotEmpty) {
        defs.add(null);
      }
      defs.add(paramDef);
      if (paramDef is GroupParameterDefinition) {
        defs.addAll(paramDef.children);
      }
    }
    return defs;
  }

  Widget _listItemBuilder(
      BuildContext context,
      int i,
      List<ParameterDefinition> flattenParamDefinitions,
      Map<String, dynamic> paramValues) {
    var paramDef = flattenParamDefinitions[i];
    var listItemWidget;
    if (paramDef is ScalarParameterDefinition) {
      listItemWidget = _createScalarParameterDefinitionItem(context, paramDef, paramValues[paramDef.name]);
    } else if (paramDef is GroupParameterDefinition) {
      listItemWidget = _createGroupParameterDefinitionItem(context, paramDef);
    } else {
      listItemWidget = Divider(color: Colors.black, thickness: 2);
    }
    return listItemWidget;
  }

  Widget _createScalarParameterDefinitionItem(
      BuildContext context, ScalarParameterDefinition paramDefinition, dynamic paramValue) {
    return ListTile(
      title: Text(
          '${AppLocalizations.of(context).dynamicMessage(paramDefinition.name)}: ${_translate(context, paramValue)}'),
      onTap: () {
        _showEditParameterDialog(paramDefinition, paramValue).then((newParamValue) {
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

  Widget _createGroupParameterDefinitionItem(BuildContext context, GroupParameterDefinition paramDef) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context).dynamicMessage(paramDef.name),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<dynamic> _showEditParameterDialog(ScalarParameterDefinition paramDef, dynamic paramValue) async {
    var dialogChildren;
    if (paramValue is bool) {
      dialogChildren = [BoolRadioButtonGroup(paramValue)];
    } else if (paramValue is int) {
      dialogChildren = [NumericInputField(paramDef, paramValue)];
    } else {
      throw UnsupportedError('Dialogs not supported for parameter of type '
          '${paramValue?.runtimeType}.');
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
          title: Text(AppLocalizations.of(context)
              .dynamicMessage(paramDef.name)),
          children: dialogChildren),
    );
  }

  String _translate(BuildContext context, dynamic paramValue) {
    var translatedValue;
    if (paramValue is bool) {
      var appLocaliztion = AppLocalizations.of(context);
      translatedValue =
          (paramValue ? appLocaliztion.boolTrue : appLocaliztion.boolFalse);
    } else if (paramValue is String) {
      translatedValue = AppLocalizations.of(context).dynamicMessage(paramValue);
    } else {
      translatedValue = paramValue?.toString();
    }
    return translatedValue;
  }
}

class BoolRadioButtonGroup extends StatefulWidget {
  final bool currentValue;

  BoolRadioButtonGroup(this.currentValue);

  @override
  State createState() => _BoolRadioButtonGroupState();
}

class _BoolRadioButtonGroupState extends State<BoolRadioButtonGroup> {
  bool _groupValue;

  _BoolRadioButtonGroupState();

  @override
  void initState() {
    super.initState();
    _groupValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context).boolTrue),
          leading: Radio(
            value: true,
            groupValue: _groupValue,
            onChanged: (bool value) {
              setState(() => _groupValue = value);
              Navigator.pop(context, _groupValue);
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).boolFalse),
          leading: Radio(
            value: false,
            groupValue: _groupValue,
            onChanged: (bool value) {
              setState(() => _groupValue = value);
              Navigator.pop(context, _groupValue);
            },
          ),
        ),
      ],
    );
  }
}

class NumericInputField extends StatefulWidget {
  final ScalarParameterDefinition _paramDef;
  final dynamic _paramValue;

  NumericInputField(this._paramDef, this._paramValue);

  @override
  State createState() => _NumericInputFieldState();
}

class _NumericInputFieldState extends State<NumericInputField> {
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
    var paramDefinition = widget._paramDef;
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        keyboardType:
            _textInputTypeByParameterType(paramDefinition.defaultValue),
        validator: (value) =>
            _validateValue(context, value, paramDefinition.validators),
        onEditingComplete: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(
                context,
                _asParameterType(
                    _controller.text, paramDefinition.defaultValue));
          }
        },
      ),
    );
  }

  String _validateValue(
      BuildContext context, String value, List<ParameterValidator> validators) {
    var strMsg;
    for (var i = 0; i < validators.length; i++) {
      var validator = validators[i];
      var parametrizedMsg = validator.validate(value);
      if (parametrizedMsg != null) {
        strMsg = AppLocalizations.of(context).dynamicMessage(
            parametrizedMsg.message,
            args: parametrizedMsg.parameters);
        break;
      }
    }
    return strMsg;
  }

  // TODO: Maybe the method should be put in ParameterDefinition
  dynamic _asParameterType(String value, dynamic defaultValue) {
    dynamic parameterValue;
    if (defaultValue is int) {
      parameterValue = int.parse(value);
    } else if (defaultValue is double) {
      parameterValue = double.parse(value);
    } else {
      throw UnsupportedError(
          'Parameter type ${defaultValue.runtimeType} not supported!');
    }
    return parameterValue;
  }

  TextInputType _textInputTypeByParameterType(dynamic value) {
    bool decimal;
    if (value is int) {
      decimal = false;
    } else if (value is double) {
      decimal = true;
    } else {
      throw UnsupportedError(
          'Parameter type ${value.runtimeType} not supported!');
    }
    return TextInputType.numberWithOptions(signed: false, decimal: decimal);
  }
}
