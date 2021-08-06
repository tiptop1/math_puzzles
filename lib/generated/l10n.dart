// GENERATED CODE - BUT ADDED Reflector CLASS AND ITS INSTAnCE invokingReflector BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectable/reflectable.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Reflector extends Reflectable {
  // declarationsCapacity - to find method
  // invokingCapability - to invoke method
  const Reflector() : super(declarationsCapability, instanceInvokeCapability);
}

const invokingReflector = Reflector();

@invokingReflector
class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Math Puzzles`
  String get applicationTitle {
    return Intl.message(
      'Math Puzzles',
      name: 'applicationTitle',
      desc: '',
      args: [],
    );
  }

  /// `New session`
  String get newSessionMenu {
    return Intl.message(
      'New session',
      name: 'newSessionMenu',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsMenu {
    return Intl.message(
      'Settings',
      name: 'settingsMenu',
      desc: '',
      args: [],
    );
  }

  /// `Puzzle`
  String get puzzleTitle {
    return Intl.message(
      'Puzzle',
      name: 'puzzleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Answer rate`
  String get answerRateTitle {
    return Intl.message(
      'Answer rate',
      name: 'answerRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show answer`
  String get showAnswerButton {
    return Intl.message(
      'Show answer',
      name: 'showAnswerButton',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get correctAnswerButton {
    return Intl.message(
      'Correct',
      name: 'correctAnswerButton',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect`
  String get incorrectAnswerButton {
    return Intl.message(
      'Incorrect',
      name: 'incorrectAnswerButton',
      desc: '',
      args: [],
    );
  }

  /// `Session summary`
  String get sessionSummaryTitle {
    return Intl.message(
      'Session summary',
      name: 'sessionSummaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get correctAnswers {
    return Intl.message(
      'Correct',
      name: 'correctAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect`
  String get incorrectAnswers {
    return Intl.message(
      'Incorrect',
      name: 'incorrectAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get boolTrue {
    return Intl.message(
      'Yes',
      name: 'boolTrue',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get boolFalse {
    return Intl.message(
      'No',
      name: 'boolFalse',
      desc: '',
      args: [],
    );
  }

  /// `Expected integer value.`
  String get intTypeValidator {
    return Intl.message(
      'Expected integer value.',
      name: 'intTypeValidator',
      desc: '',
      args: [],
    );
  }

  /// `Expected logic value - "true" or "false".`
  String get boolTypeValidator {
    return Intl.message(
      'Expected logic value - "true" or "false".',
      name: 'boolTypeValidator',
      desc: '',
      args: [],
    );
  }

  /// `Allowed value between {minValue} and {maxValue}.`
  String numParameterScopeValidator(Object minValue, Object maxValue) {
    return Intl.message(
      'Allowed value between $minValue and $maxValue.',
      name: 'numParameterScopeValidator',
      desc: '',
      args: [minValue, maxValue],
    );
  }

  /// `At least one generator must be enabled.`
  String generatorDisableValidator(Object minValue, Object maxValue) {
    return Intl.message(
      'At least one generator must be enabled.',
      name: 'generatorDisableValidator',
      desc: '',
      args: [minValue, maxValue],
    );
  }

  /// `Addition`
  String get additionGenerator {
    return Intl.message(
      'Addition',
      name: 'additionGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get additionGenerator_enabled {
    return Intl.message(
      'Enabled',
      name: 'additionGenerator_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Max result`
  String get additionGenerator_maxResult {
    return Intl.message(
      'Max result',
      name: 'additionGenerator_maxResult',
      desc: '',
      args: [],
    );
  }

  /// `Number of digits after the decimal point`
  String get additionGenerator_fractionDigits {
    return Intl.message(
      'Number of digits after the decimal point',
      name: 'additionGenerator_fractionDigits',
      desc: '',
      args: [],
    );
  }

  /// `Subtraction`
  String get subtractionGenerator {
    return Intl.message(
      'Subtraction',
      name: 'subtractionGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get subtractionGenerator_enabled {
    return Intl.message(
      'Enabled',
      name: 'subtractionGenerator_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Max result`
  String get subtractionGenerator_maxResult {
    return Intl.message(
      'Max result',
      name: 'subtractionGenerator_maxResult',
      desc: '',
      args: [],
    );
  }

  /// `Number of digits after the decimal point`
  String get subtractionGenerator_fractionDigits {
    return Intl.message(
      'Number of digits after the decimal point',
      name: 'subtractionGenerator_fractionDigits',
      desc: '',
      args: [],
    );
  }

  /// `Percentage`
  String get percentageGenerator {
    return Intl.message(
      'Percentage',
      name: 'percentageGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get percentageGenerator_enabled {
    return Intl.message(
      'Enabled',
      name: 'percentageGenerator_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Max result`
  String get percentageGenerator_maxResult {
    return Intl.message(
      'Max result',
      name: 'percentageGenerator_maxResult',
      desc: '',
      args: [],
    );
  }

  /// `Number of digits after the decimal point`
  String get percentageGenerator_fractionDigits {
    return Intl.message(
      'Number of digits after the decimal point',
      name: 'percentageGenerator_fractionDigits',
      desc: '',
      args: [],
    );
  }

  /// `Multiplication Table`
  String get multiplicationTableGenerator {
    return Intl.message(
      'Multiplication Table',
      name: 'multiplicationTableGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get multiplicationTableGenerator_enabled {
    return Intl.message(
      'Enabled',
      name: 'multiplicationTableGenerator_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Multiplication times`
  String get multiplicationTableGenerator_multiplicationTimes {
    return Intl.message(
      'Multiplication times',
      name: 'multiplicationTableGenerator_multiplicationTimes',
      desc: '',
      args: [],
    );
  }

  /// `Division`
  String get divisionGenerator {
    return Intl.message(
      'Division',
      name: 'divisionGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get divisionGenerator_enabled {
    return Intl.message(
      'Enabled',
      name: 'divisionGenerator_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Max result`
  String get divisionGenerator_maxResult {
    return Intl.message(
      'Max result',
      name: 'divisionGenerator_maxResult',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get session {
    return Intl.message(
      'Session',
      name: 'session',
      desc: '',
      args: [],
    );
  }

  /// `Number of puzzles`
  String get session_puzzlesCount {
    return Intl.message(
      'Number of puzzles',
      name: 'session_puzzlesCount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'pl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
