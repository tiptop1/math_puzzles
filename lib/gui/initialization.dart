import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InitializationWidget extends StatefulWidget {
  final VoidCallback initializationCallback;
  final int delay;

  const InitializationWidget({
    this.delay,
    @required this.initializationCallback,
  });

  @override
  _InitializationWidgetState createState() => _InitializationWidgetState();
}

class _InitializationWidgetState extends State<InitializationWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.delay != null) {
      Future.delayed(
        Duration(milliseconds: widget.delay),
            () => widget.initializationCallback(),
      );
    } else {
      widget.initializationCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
