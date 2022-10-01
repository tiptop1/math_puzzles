import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/settings_bloc.dart';
import '../data/config/configuration.dart';
import '../generated/l10n.dart';
import '../utils/app_constants.dart';
import 'edit_bool_parameter_widget.dart';
import 'edit_int_parameter_widget.dart';
import 'parameter_definition/parameter_definition.dart';
import 'progress_indicator_widget.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paramDefs =
        _flatParameterDefinitions(AppConstants.parameterDefinitions);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(AppLocalizations.of(context).settingsMenu),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => _buildParameter(context, paramDefs[i]),
      ),
    );
  }

  Widget _buildParameter(BuildContext context, ParameterDefinition? paramDef) {
    var widget;
    if (paramDef == null) {
      widget = Divider(color: Colors.black, thickness: 2);
    } else if (paramDef is GroupParameterDefinition) {
      widget = _buildGroupParameter(context, paramDef);
    } else if (paramDef is ValueParameterDefinition) {
      widget = _buildValueParameter(context, paramDef);
    } else {
      throw UnsupportedError(
          'Parameter definition for "${paramDef.name}" of type ${paramDef.runtimeType} is not supported.');
    }
    return widget;
  }

  Widget _buildGroupParameter(
      BuildContext context, GroupParameterDefinition groupDef) {
    return ListTile(
      title: Text(
        _translate(context, groupDef.name),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // TODO: How to find translation in dynamic way?
  String _translate(BuildContext context, String str) {
    var localizations = AppLocalizations.of(context);
    var translatedStr;
    if (str == Configuration.sesstionGroup) {
      translatedStr = localizations.session;
    } else if (str == Configuration.additionGroup) {
      translatedStr = localizations.additionGenerator;
    } else if (str == Configuration.subtractionGroup) {
      translatedStr = localizations.multiplicationTableGenerator;
    } else if (str == Configuration.multiplicationTableGroup) {
      translatedStr = localizations.multiplicationTableGenerator;
    } else if (str == Configuration.divisionGroup) {
      translatedStr = localizations.divisionGenerator;
    } else if (str == Configuration.percentageGroup) {
      translatedStr = localizations.percentageGenerator;
    } else {
      throw UnsupportedError('Could not find translation for "$str".');
    }
    return translatedStr;
  }

  List<ParameterDefinition?> _flatParameterDefinitions(
      List<ParameterDefinition> paramDefs) {
    var flattenList = <ParameterDefinition?>[];

    for (var i = 0; i < paramDefs.length; i++) {
      var paramDef = paramDefs[i];
      var isGroup = paramDef is GroupParameterDefinition;
      if (isGroup && i > 0) {
        flattenList.add(null);
      }

      flattenList.add(paramDef);

      if (isGroup) {
        paramDef.children.forEach((e) => flattenList.add(e));
      }

      return flattenList;
    }

    return flattenList;
  }

  Widget _buildValueParameter(
      BuildContext context, ValueParameterDefinition<Object> paramDef) {
    var bloc = BlocProvider.of<SettingsBloc>(context);
    var paramName = paramDef.name;
    return StreamBuilder<Object>(
        stream: bloc.getParametersValueStream(paramName),
        builder: (context, snapshot) {
          var widget;
          if (snapshot.hasData) {
            var paramVal = snapshot.data;
            assert(paramVal != null, 'Parameter "$paramName" has null value');
            widget = ListTile(
              title: Text('${_translate(context, paramName)}: $paramVal'),
              onTap: () {
                _showEditParameterDialog(context, paramDef, paramVal!)
                    .then((newParamVal) {
                  if (newParamVal != paramVal) {
                    bloc.setParameterValue(paramDef.name, newParamVal);
                  }
                });
              },
            );
          } else {
            widget = ProgressIndicatorWidget();
          }
          return widget;
        });
  }

  Future<Object> _showEditParameterDialog(BuildContext context,
      ValueParameterDefinition paramDef, Object paramVal) async {
    var dialogChildren;
    if (paramVal is bool) {
      dialogChildren = [EditBoolParameterWidget(paramDef, paramVal)];
    } else if (paramVal is int) {
      dialogChildren = [EditIntParameterWidget(paramDef, paramVal)];
    } else {
      throw UnsupportedError('Dialogs not supported for parameter of type '
          '${paramVal.runtimeType}.');
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
          title: Text(_translate(context, paramDef.name)),
          children: dialogChildren),
    );
  }
}
