import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

/// Configuration parameter validator.
/// It assume that parameter will be provided as String - it's because input
/// parameters are entered as text.
abstract class ParameterValidator<T> {
  const ParameterValidator();

  /// If [value] valid return null otherwise errorMessage.
  String? validate(BuildContext context, T? value);
}

/// Predefined value scope validator.
class IntParameterScopeValidator extends ParameterValidator<int> {
  static const String name = 'numParameterScopeValidator';

  final int minValue;
  final int maxValue;

  const IntParameterScopeValidator(this.minValue, this.maxValue);

  @override
  String? validate(BuildContext context, int? value) =>
      (value == null || value < minValue || value > maxValue)
          ? AppLocalizations.of(context).intParameterScopeValidator(minValue, maxValue)
          : null;
}


