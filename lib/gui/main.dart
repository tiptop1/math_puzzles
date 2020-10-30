import 'package:flutter/material.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/gui/initialization.dart';
import 'package:math_puzzles/gui/main.reflectable.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';

void main() {
  // Set up reflection support.
  initializeReflectable();
  runApp(MainWidget());
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainWidget> with WidgetsBindingObserver {
  Configuration _configuration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _configuration.store();
    }
  }

  @override
  Widget build(BuildContext context) {
    var widget;
    if (_configuration != null) {
      widget = MathPuzzleWidget(_configuration);
    } else {
      widget = InitializationWidget(
          delay: 2000,
          initializationCallback: () => Configuration.load().then(
                (c) => setState(() {
                  _configuration = c;
                }),
              ));
    }
    return widget;
  }
}
