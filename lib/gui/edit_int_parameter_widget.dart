import 'package:flutter/material.dart';
import 'package:math_puzzles/generated/l10n.dart';

import 'parameter_definition/parameter_definition.dart';

class EditIntParameterWidget extends StatefulWidget {
  final ValueParameterDefinition _paramDefinition;
  final dynamic _paramValue;

  EditIntParameterWidget(this._paramDefinition, this._paramValue);

  @override
  State createState() => _IntInputFieldState();
}

class _IntInputFieldState extends State<EditIntParameterWidget> {
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
    var paramDef = widget._paramDefinition;
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        keyboardType:
        TextInputType.numberWithOptions(signed: false, decimal: true),
        validator: (value) {
          var convertedValue = paramDef.convertValue(value);
            return convertedValue == null ? AppLocalizations.of(context).intValueConverter : paramDef.validateValue(context, convertedValue);
        },
        onEditingComplete: () {
          var formState = _formKey.currentState;
          if (formState != null && formState.validate()) {
            Navigator.pop(context, paramDef.convertValue(_controller.text));
          }
        },
      ),
    );
  }
}