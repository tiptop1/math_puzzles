import 'package:flutter/material.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/gui/initialization.dart';
import 'package:math_puzzles/gui/main.reflectable.dart';
import 'package:math_puzzles/gui/math_puzzle.dart';
import 'dart:developer' as developer;

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
  bool _initialized = false;
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
