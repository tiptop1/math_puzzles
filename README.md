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

## How to build project

To compile the project it's necessary to use build_runner package to generate code for reflectable
package (for details see [reflectable API documentation](https://pub.dev/documentation/reflectable/latest/)).

To do that in root directory of the project execute command:
$ flutter pub run build_runner build gui
The command should generate files lib/gui/main.reflectable.dart which is imported everything in
project where reflection is used and file test/puzzle_generator_test.reflectable.dart for tests.

