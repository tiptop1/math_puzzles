import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_puzzles/l10n/messages_all.dart';
import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  // invokingCapability,
  const Reflector() : super(declarationsCapability, instanceInvokeCapability);
}

const invokingReflector = Reflector();

@invokingReflector
class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    var name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    var localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String get applicationTitle =>
      Intl.message('Math Puzzles', name: 'applicationTitle');

  String get newSessionMenu =>
      Intl.message('New session', name: 'newSessionMenu');

  String get settingsMenu => Intl.message('Settings', name: 'settingsMenu');

  String get puzzleTitle =>
      Intl.message("Puzzle", name: 'puzzleTitle');

  String get answerRateTitle =>
      Intl.message('Answer rate', name: 'answerRateTitle');

  String get showAnswerButton =>
      Intl.message('Show answer', name: 'showAnswerButton');

  String get correctAnswerButton =>
      Intl.message('Correct', name: 'correctAnswerButton');

  String get incorrectAnswerButton =>
      Intl.message('Incorrect', name: 'incorrectAnswerButton');

  String get sessionSummaryTitle =>
      Intl.message('Session summary', name: 'sessionSummaryTitle');

  String get correctAnswers =>
      Intl.message('Correct answers', name: 'correctAnswers');

  String get incorrectAnswers =>
      Intl.message('Incorrect answers', name: 'incorrectAnswers');

  String get boolTrue => Intl.message('Yes', name: 'boolTrue');

  String get boolFalse => Intl.message('No', name: 'boolFalse');

  // Notice: dynamicMassage(...) can call just regular methods and not getters.

  // Validators
  String intTypeValidator() =>
      Intl.message('Expected integer value.', name: 'intTypeValidator');

  String boolTypeValidator() =>
      Intl.message('Expected logic value - "true" or "false".',
          name: 'boolTypeValidator');

  String numParameterScopeValidator(num minValue, num maxValue) =>
      Intl.message('Allowed value between $minValue and ${maxValue}.',
          name: 'numParameterScopeValidator', args: [minValue, maxValue]);

  // Puzzle generator parameters
  // Addition Generator
  String additionGenerator() =>
      Intl.message('Addition', name: 'additionGenerator');

  String additionGenerator_enabled() =>
      Intl.message('Enabled', name: 'additionGenerator_enabled');

  String additionGenerator_maxResult() =>
      Intl.message('Max result', name: 'additionGenerator_maxResult');

  String additionGenerator_fractionDigits() =>
      Intl.message('Number of digits after the decimal point',
          name: 'additionGenerator_fractionDigits');

  // Percentage Generator
  String percentageGenerator() =>
      Intl.message('Percentage', name: 'percentageGenerator');

  String percentageGenerator_enabled() =>
      Intl.message('Enabled', name: 'percentageGenerator_enabled');

  String percentageGenerator_maxResult() =>
      Intl.message('Max result', name: 'percentageGenerator_maxResult');

  String percentageGenerator_fractionDigits() =>
      Intl.message('Number of digits after the decimal point',
          name: 'percentageGenerator_fractionDigits');

  // Multiplication Table Generator
  String multiplicationTableGenerator() => Intl.message('Multiplication Table',
      name: 'multiplicationTableGenerator');

  String multiplicationTableGenerator_enabled() =>
      Intl.message('Enabled', name: 'multiplicationTableGenerator_enabled');

  String multiplicationTableGenerator_multiplicationTimes() =>
      Intl.message('Multiplication times',
          name: 'multiplicationTableGenerator_multiplicationTimes');

  // General parameters
  String session() => Intl.message('Session', name: 'session');

  String session_puzzlesCount() =>
      Intl.message('Number of puzzles', name: 'session_puzzlesCount');

  String dynamicMessage(String name, {List<dynamic> args = const []}) {
    var instanceMirror = invokingReflector.reflect(this);
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
      message = instanceMirror.invoke(methodName, args);
    } else {
      message = '#$name#';
    }
    return message;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pl'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
