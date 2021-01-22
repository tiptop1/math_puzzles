// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(minValue, maxValue) => "Allowed value between ${minValue} and ${maxValue}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "additionGenerator" : MessageLookupByLibrary.simpleMessage("Addition"),
    "additionGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Enabled"),
    "additionGenerator_fractionDigits" : MessageLookupByLibrary.simpleMessage("Number of digits after the decimal point"),
    "additionGenerator_maxResult" : MessageLookupByLibrary.simpleMessage("Max result"),
    "answerRateTitle" : MessageLookupByLibrary.simpleMessage("Answer rate"),
    "applicationTitle" : MessageLookupByLibrary.simpleMessage("Math Puzzles"),
    "boolFalse" : MessageLookupByLibrary.simpleMessage("No"),
    "boolTrue" : MessageLookupByLibrary.simpleMessage("Yes"),
    "boolTypeValidator" : MessageLookupByLibrary.simpleMessage("Expected logic value - \"true\" or \"false\"."),
    "correctAnswerButton" : MessageLookupByLibrary.simpleMessage("Correct"),
    "correctAnswers" : MessageLookupByLibrary.simpleMessage("Correct answers"),
    "incorrectAnswerButton" : MessageLookupByLibrary.simpleMessage("Incorrect"),
    "incorrectAnswers" : MessageLookupByLibrary.simpleMessage("Incorrect answers"),
    "intTypeValidator" : MessageLookupByLibrary.simpleMessage("Expected integer value."),
    "multiplicationTableGenerator" : MessageLookupByLibrary.simpleMessage("Multiplication Table"),
    "multiplicationTableGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Enabled"),
    "multiplicationTableGenerator_multiplicationTimes" : MessageLookupByLibrary.simpleMessage("Multiplication times"),
    "newSessionMenu" : MessageLookupByLibrary.simpleMessage("New session"),
    "numParameterScopeValidator" : m0,
    "percentageGenerator" : MessageLookupByLibrary.simpleMessage("Percentage"),
    "percentageGenerator_enabled" : MessageLookupByLibrary.simpleMessage("Enabled"),
    "percentageGenerator_fractionDigits" : MessageLookupByLibrary.simpleMessage("Number of digits after the decimal point"),
    "percentageGenerator_maxResult" : MessageLookupByLibrary.simpleMessage("Max result"),
    "puzzleTitle" : MessageLookupByLibrary.simpleMessage("Puzzle"),
    "session" : MessageLookupByLibrary.simpleMessage("Session"),
    "sessionSummaryTitle" : MessageLookupByLibrary.simpleMessage("Session summary"),
    "session_puzzlesCount" : MessageLookupByLibrary.simpleMessage("Number of puzzles"),
    "settingsMenu" : MessageLookupByLibrary.simpleMessage("Settings"),
    "showAnswerButton" : MessageLookupByLibrary.simpleMessage("Show answer")
  };
}
