import 'package:flutter/material.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/gui/initialization.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainWidget> {
  bool _initialized = false;
  Configuration _configuration;

  @override
  void dispose() {
    _configuration.store();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return MathPuzzleWidget(_configuration);
    } else {
      return InitializationWidget(
          delay: 2000,
          initializationCallback: () => Configuration.load().then(
                (configuration) => setState(() {
                  _initialized = true;
                  _configuration = configuration;
                }),
              ));
    }
  }
}
