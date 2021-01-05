// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pl';

  static m0(minValue, maxValue) => "Dozwolona wartość pomiędzy ${minValue} i ${maxValue}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "additionGenerator" : MessageLookupByLibrary.simpleMessage("Dodawanie"),
    "additionGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Włącz"),
    "additionGenerator_fractionDigits" : MessageLookupByLibrary.simpleMessage("Ilość cyfr po kropce"),
    "additionGenerator_maxResult" : MessageLookupByLibrary.simpleMessage("Wynik maksymalny"),
    "applicationTitle" : MessageLookupByLibrary.simpleMessage("Zagadki matematyczne"),
    "boolFalse" : MessageLookupByLibrary.simpleMessage("Nie"),
    "boolTrue" : MessageLookupByLibrary.simpleMessage("Tak"),
    "boolTypeValidator" : MessageLookupByLibrary.simpleMessage("Wymagana wartość logiczna - \"Tak\" lub \"Nie\"."),
    "correctAnswerButton" : MessageLookupByLibrary.simpleMessage("Prawidłowa"),
    "correctAnswers" : MessageLookupByLibrary.simpleMessage("Prawidłowa odpowiedź"),
    "incorrectAnswerButton" : MessageLookupByLibrary.simpleMessage("Błędna"),
    "incorrectAnswers" : MessageLookupByLibrary.simpleMessage("Błędna odpowiedź"),
    "intTypeValidator" : MessageLookupByLibrary.simpleMessage("Wymagana liczba całkowita."),
    "multiplicationTableGenerator" : MessageLookupByLibrary.simpleMessage("Tabliczka mnożenia"),
    "multiplicationTableGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Włącz"),
    "multiplicationTableGenerator_multiplicationTimes" : MessageLookupByLibrary.simpleMessage("Rozmiar tabliczki mnożenia"),
    "newSessionMenu" : MessageLookupByLibrary.simpleMessage("Nowa sesja"),
    "numParameterScopeValidator" : m0,
    "percentageGenerator" : MessageLookupByLibrary.simpleMessage("Procentowanie"),
    "percentageGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Włącz"),
    "percentageGenerator_fractionDigits" : MessageLookupByLibrary.simpleMessage("Ilość cyfr po kropce"),
    "percentageGenerator_maxResult" : MessageLookupByLibrary.simpleMessage("Wynik maksymalny"),
    "puzzleQuestion" : MessageLookupByLibrary.simpleMessage("Jaka jest odpowiedź?"),
    "session" : MessageLookupByLibrary.simpleMessage("Session"),
    "sessionSummary" : MessageLookupByLibrary.simpleMessage("Podsumowanie sesji"),
    "session_puzzlesCount" : MessageLookupByLibrary.simpleMessage("Ilość zagadek"),
    "settingsMenu" : MessageLookupByLibrary.simpleMessage("Ustawienia"),
    "showAnswerButton" : MessageLookupByLibrary.simpleMessage("Pokaż odpowiedź")
  };
}
