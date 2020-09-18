import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:math_puzzles/l10n/messages_all.dart';

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

  String get puzzleQuestion =>
      Intl.message("What's the answer?", name: 'puzzleQuestion');

  String get showAnswerButton =>
      Intl.message('Show answer', name: 'showAnswerButton');

  String get correctAnswerButton =>
      Intl.message('Correct', name: 'correctAnswerButton');

  String get incorrectAnswerButton =>
      Intl.message('Incorrect', name: 'incorrectAnswerButton');

  String get sessionSummary =>
      Intl.message('Session summary', name: 'sessionSummary');

  String get correctAnswersCount =>
      Intl.message('Correct answers count:', name: 'correctAnswersCount');

  String get incorrectAnswersCount =>
      Intl.message('Incorrect answers count:', name: 'incorrectAnswersCount');
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
