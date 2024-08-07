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
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var paramDefs =
        _flatParameterDefinitions(AppConstants.parameterDefinitions);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(AppLocalizations.of(context).settingsMenu),
      ),
      body: StreamBuilder<Map<String, Object>>(
        stream: BlocProvider.of<SettingsBloc>(context).stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index) =>
                    _createListTile(context, paramDefs[index], snapshot.data!),
                itemCount: paramDefs.length);
          } else {
            return ProgressIndicatorWidget();
          }
        },
      ),
    );
  }

  Widget _createListTile(BuildContext context, ParameterDefinition? paramDef,
      Map<String, Object> parameters) {
    Widget widget;
    if (paramDef == null) {
      widget = Divider(color: Colors.black, thickness: 2);
    } else if (paramDef is GroupParameterDefinition) {
      widget = _buildGroupParameter(context, paramDef);
    } else if (paramDef is ValueParameterDefinition) {
      widget = _buildValueParameter(context, paramDef, parameters);
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

  // TODO: How to get translation in dynamic way?
  String _translate(BuildContext context, String str) {
    var localizations = AppLocalizations.of(context);
    String translatedStr = '???';
    switch (str) {
      case Configuration.sessionsPuzzlesCountParam:
        translatedStr = localizations.session_puzzlesCount;
        break;
      case Configuration.sesstionGroup:
        translatedStr = localizations.session;
        break;
      case Configuration.additionGroup:
        translatedStr = localizations.additionGenerator;
        break;
      case Configuration.additionEnabledParam:
        translatedStr = localizations.additionGenerator_enabled;
        break;
      case Configuration.additionMaxResultParam:
        translatedStr = localizations.additionGenerator_maxResult;
        break;
      case Configuration.additionFractionDigits:
        translatedStr = localizations.additionGenerator_fractionDigits;
        break;
      case Configuration.subtractionGroup:
        translatedStr = localizations.subtractionGenerator;
        break;
      case Configuration.subtractionEnabledParam:
        translatedStr = localizations.subtractionGenerator_enabled;
        break;
      case Configuration.subtractionMaxResultParam:
        translatedStr = localizations.subtractionGenerator_maxResult;
        break;
      case Configuration.subtractionFractionDigitsParam:
        translatedStr = localizations.subtractionGenerator_fractionDigits;
        break;
      case Configuration.multiplicationTableGroup:
        translatedStr = localizations.multiplicationTableGenerator;
        break;
      case Configuration.multiplicationTableEnabledParam:
        translatedStr = localizations.multiplicationTableGenerator_enabled;
        break;
      case Configuration.multiplicationTableMultiplierParam:
        translatedStr = localizations.multiplicationTableGenerator_multiplier;
        break;
      case Configuration.multiplicationTableMultiplicandParam:
        translatedStr = localizations.multiplicationTableGenerator_multiplicand;
        break;
      case Configuration.divisionGroup:
        translatedStr = localizations.divisionGenerator;
        break;
      case Configuration.divisionEnabledParam:
        translatedStr = localizations.divisionGenerator_enabled;
        break;
      case Configuration.divisionMaxResultParam:
        translatedStr = localizations.divisionGenerator_maxResult;
        break;
      case Configuration.percentageGroup:
        translatedStr = localizations.percentageGenerator;
        break;
      case Configuration.percentageEnabledParam:
        translatedStr = localizations.percentageGenerator_enabled;
        break;
      case Configuration.percentageMaxResultParam:
        translatedStr = localizations.percentageGenerator_maxResult;
        break;
      case Configuration.percentageFractionDigitsParam:
        translatedStr = localizations.percentageGenerator_fractionDigits;
        break;
      default:
        UnsupportedError('Could not find translation for "$str".');
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
        for (var child in paramDef.children) {
          flattenList.add(child);
        }
      }
    }

    return flattenList;
  }

  Widget _buildValueParameter(
      BuildContext context,
      ValueParameterDefinition<Object> paramDef,
      Map<String, Object> parameters) {
    var bloc = BlocProvider.of<SettingsBloc>(context);
    var paramName = paramDef.name;
    var paramVal = parameters[paramName];
    return ListTile(
      title: Text('${_translate(context, paramName)}: $paramVal'),
      onTap: () {
        _showEditParameterDialog(context, paramDef, paramVal!)
            .then((newParamVal) {
          if (newParamVal != null && newParamVal != paramVal) {
            bloc.setParameterValue(paramDef.name, newParamVal);
          }
        });
      },
    );
  }

  Future<Object?> _showEditParameterDialog(BuildContext context,
      ValueParameterDefinition paramDef, Object paramVal) async {
    List<Widget> dialogChildren;
    if (paramVal is bool) {
      dialogChildren = [EditBoolParameterWidget(paramDef, paramVal)];
    } else if (paramVal is int) {
      dialogChildren = [EditIntParameterWidget(paramDef, paramVal)];
    } else {
      throw UnsupportedError('Dialogs not supported for parameter of type '
          '${paramVal.runtimeType}.');
    }
    return await showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
          title: Text(_translate(context, paramDef.name)),
          children: dialogChildren),
    );
  }
}
