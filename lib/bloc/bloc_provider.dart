import 'package:flutter/material.dart';

import 'bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const BlocProvider({super.key, required this.bloc, required this.child});

  static T of<T extends Bloc>(BuildContext context) {
    BlocProvider<T> provider;
    provider = context.findAncestorWidgetOfExactType()!;
    return provider.bloc;
  }

  @override
  State<BlocProvider> createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
