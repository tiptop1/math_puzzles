import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_puzzles/configuration.dart';
import 'package:math_puzzles/puzzle_generator.dart';
import 'package:math_puzzles/session.dart';

import 'localizations.dart';

void main() => runApp(MathPuzzleWidget());

class MathPuzzleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MathPuzzleState();
  }
}

class _MathPuzzleState extends State<MathPuzzleWidget> {
  static const String _action_value_route = 'ACTION_ROUTE';
  static const String _action_prefix_generator = 'GENERATOR:';

  Configuration _configuration;
  Session _session;

  _MathPuzzleState() {
    _configuration = Configuration.instance();
    _session = Session(_configuration);
  }

  _correctAnswerCallback() {
    setState(() {
      _session.increaseCorrectAnswersCount();
    });
  }

  _incorrectAnswerCallback() {
    setState(() {
      _session.increaseIncorrectAnswersCount();
    });
  }

  _showAnswerCallback() {
    setState(() => _session.puzzleAnswered = true);
  }

  _selectPopupMenuCallback(String actionValue) {
    if (actionValue == _action_value_route) {
      // TOOD: Implement settings windows appear
    } else if (actionValue?.startsWith(_action_prefix_generator) ?? false) {
      String generatorName = actionValue.substring(_action_prefix_generator.length);
      String generatorEnabledParam = '$generatorName.${PuzzleGenerator.paramEnabledPostfix}';
      _configuration.parameters[generatorEnabledParam] = !_configuration.parameters[generatorEnabledParam];
    }
  }

  @override
  void initState() {
    super.initState();
    _configuration.load().then((conf) {
      // Confiugration parameters loaded.
      setState(() => {});
    });
  }

  @override
  void dispose() {
    _configuration.store();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Math puzzles'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _selectPopupMenuCallback,
              itemBuilder: (buildContext) {
                return [
                  ...(_configuration.availableGenerators
                      .map((g) => CheckedPopupMenuItem<String>(
                            value: '$_action_prefix_generator${g.name}',
                            checked: _configuration.parameters[
                                '${g.name}.${PuzzleGenerator.paramEnabledPostfix}'],
                            child: Text(g.name),
                          ))),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                      value: _action_value_route, child: Text('Settings')),
                ];
              },
            )
          ],
        ),
        body: Column(
          children: [
            Text(
                '${_session.currentPuzzle.question} = ${_session.puzzleAnswered ? _session.currentPuzzle.answer : '?'}'),
            AnswerButtonsWidget(_session, _showAnswerCallback,
                _correctAnswerCallback, _incorrectAnswerCallback),
          ],
        ),
      ),
    );
  }
}

class AnswerButtonsWidget extends StatelessWidget {
  final Session _session;
  final Function _showAnswerCallback;
  final Function _correctAnswerCallback;
  final Function _incorrectAnswerCallback;

  AnswerButtonsWidget(this._session, this._showAnswerCallback,
      this._correctAnswerCallback, this._incorrectAnswerCallback);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (!_session.puzzleAnswered) {
      widget = RaisedButton(
        child: Text(AppLocalizations.of(context).showAnswer),
        onPressed: _showAnswerCallback,
      );
    } else {
      widget = Row(
        children: [
          RaisedButton(
              child: Text(AppLocalizations.of(context).incorrect),
              onPressed: _incorrectAnswerCallback),
          RaisedButton(
              child: Text(AppLocalizations.of(context).correct),
              onPressed: _correctAnswerCallback),
        ],
      );
    }
    return widget;
  }
}
