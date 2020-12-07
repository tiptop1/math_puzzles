# Math Puzzles

## What's the goal

This project is Flutter learning sand box.

Its goal is to create application generating some math puzzles.

## Build project
The project uses some external tools, so to build code you have to do some extra work.

### Annotations and dynamic method invocation
To compile the project it's necessary to use build_runner package to generate code for reflectable
package (for details see [reflectable API documentation](https://pub.dev/documentation/reflectable/latest/)).

To generate files lib/gui/main.reflectable.dart which is imported everything in
project where reflection is used and file test/*_test.reflectable.dart for tests,
in root directory of the project run command:
$ flutter pub run build_runner build gui

### Translations
If some translated strings have been changed (added) it's necessary to regenerate translation
bundles in following steps:
Extract translations to .arb files:
$ flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart
The command create file lib\l10n\intl_messages.arb. This is English tranlastion - rename it to lib\l10n\intl_en.arb
Based on the file, create translation files for required languages - e.g. intl_pl.arb.

If you created translation files for required languages, run command:
non-Windows OS:
$ flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_*.arb

Windows (doesn't support file name wildcarding):
$ flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_pl.arb lib/l10n/intl_en.arb

After translation regeneration don't miss to regenerate dynamic method invocation reflectors - see section 'Annotations and dynamic method invocation'


