# Math Puzzles

## What's the goal

This project is Flutter learning sand box.

Its goal is to create application generating some math puzzles.

## Build project
The project uses some external tools, so to build code you have to do some extra work.

### Translations
If some translated strings have been changed (added) it's necessary to regenerate translation
bundles in following steps:
flutter pub run intl_utils:generate
Keep in mind that translation class AppLocalizations need dynamic methodo invocation.

### Annotations and dynamic method invocation
To compile the project it's necessary to use build_runner package to generate code for reflectable
package (for details see [reflectable API documentation](https://pub.dev/documentation/reflectable/latest/)).

To generate files lib/gui/main.reflectable.dart which is imported everything in
project where reflection is used and file test/*_test.reflectable.dart for tests,
in root directory of the project run command:
$ flutter pub run build_runner build gui

### Generate launcher adaptive icons
To create launcher adaptive icons run:
$ flutter pub run flutter_launcher_icons:main
