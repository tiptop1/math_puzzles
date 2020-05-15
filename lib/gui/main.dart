import 'package:flutter/material.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';

import 'package:math_puzzles/gui/initialization.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainWidget> {
  bool _initialized = false;

  @override
  void dispose() {
    Configuration.instance().store();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return MathPuzzleWidget();
    } else {
      return InitializationWidget(
        delay: 2000,
        initializationCallback: () => Configuration.instance()
            .load()
            .then((_) => setState(() => _initialized = true)),
      );
    }
  }
}
