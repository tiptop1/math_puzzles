import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'parameter_definition/parameter_definition.dart';

class EditBoolParameterWidget extends StatefulWidget {
  final ValueParameterDefinition _paramDefinition;
  final bool _paramValue;

  EditBoolParameterWidget(this._paramDefinition, this._paramValue);

  @override
  State createState() => _EditBoolParameterWidgetState();
}

class _EditBoolParameterWidgetState extends State<EditBoolParameterWidget> {
  bool _groupValue = false;
  String? _validationMsg;

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
          onChanged: (bool? newValue) => onChangeHandler(context, newValue),
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).boolFalse),
        leading: Radio(
          value: false,
          groupValue: _groupValue,
          onChanged: (bool? newValue) => onChangeHandler(context, newValue),
        ),
      ),
    ];

    Divider divider;
    Text? text;

    if (_validationMsg != null) {
      var theme = Theme.of(context);
      divider = Divider(
        color: Colors.red,
        thickness: 1.0,
      );
      text = Text(_validationMsg!,
          style: theme.textTheme.displaySmall!.apply(color: Colors.red));
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

  void onChangeHandler(BuildContext context, bool? newValue) {
    _validationMsg = newValue == null
        ? AppLocalizations.of(context).boolValueConverter
        : widget._paramDefinition.validateValue(context, newValue);
    setState(() => _groupValue = (newValue ?? false));
    if (_validationMsg == null) {
      Navigator.pop(context, _groupValue);
    }
  }
}
