import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'parameter_definition/parameter_definition.dart';
import 'parameter_definition/parameter_validators.dart';

class EditBoolParameterWidget extends StatefulWidget {
  final ValueParameterDefinition _paramDefinition;
  final bool _paramValue;

  EditBoolParameterWidget(this._paramDefinition, this._paramValue);

  @override
  State createState() => _EditBoolParameterWidgetState();
}

class _EditBoolParameterWidgetState extends State<EditBoolParameterWidget> {
  bool _groupValue = false;
  ParametrizedMessage? _newValueValidationMsg;

  _EditBoolParameterWidgetState();

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
    _newValueValidationMsg = widget._paramDefinition.validateValue(newValue);
    setState(() => _groupValue = (newValue ?? false));
    if (_newValueValidationMsg == null) {
      Navigator.pop(context, _groupValue);
    }
  }
}