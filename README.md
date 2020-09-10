# math_puzzles

Math Puzzles application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build project
The project uses some external tools, so to build code you have to do some extra work.

### Annotations
To compile the project it's necessary to use build_runner package to generate code for reflectable
package (for details see [reflectable API documentation](https://pub.dev/documentation/reflectable/latest/)).

To generate files lib/gui/main.reflectable.dart which is imported everything in
project where reflection is used and file test/puzzle_generator_test.reflectable.dart for tests,
in root directory of the project run command:
$ flutter pub run build_runner build gui

### Translations
If some translated strings have been changed (added) regenerate translation bundles in following steps:
Extract translations to .arb files:
$ flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart
The command create file lib\l10n\intl_messages.arb. This is English tranlastion - rename it to lib\l10n\intl_en.arb
Based on the file, create translation files for required languages - e.g. intl_pl.arb.

If you created translation files for required languages, run command:
non-Windows OS:
$ flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_*.arb

Windows (doesn't support file name wildcarding):
$ flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_pl.arb lib/l10n/intl_en.arb



