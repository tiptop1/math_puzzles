import 'package:flutter/material.dart';
import 'package:math_puzzles/bloc/bloc_provider.dart';
import 'package:math_puzzles/bloc/math_puzzle_bloc.dart';
import 'package:math_puzzles/generated/l10n.dart';

import '../data/lecture.dart';
import 'math_puzzle_widget.dart';
import 'session_summary_widget.dart';

class Route {
  static const String puzzle = '/';
  static const String settings = '/settings';
}

class MathPuzzleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MathPuzzleBloc>(context);
    return StreamBuilder<Lecture>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          var localizations = AppLocalizations.of(context);
          var lecture = snapshot.data!;
          var title = lecture.finished
              ? localizations.sessionSummaryTitle
              : (lecture.puzzleAnswered
                  ? localizations.answerRateTitle
                  : localizations.puzzleTitle);
          return Scaffold(
            appBar: AppBar(
              leading: null,
              title: Text(title),
              automaticallyImplyLeading: false,
              actions: createPopupMenuButton(context, bloc),
            ),
            body: lecture.finished
                ? SessionSummaryWidget(lecture)
                : MathPuzzleWidget(lecture),
          );
        });
  }

  List<Widget> createPopupMenuButton(BuildContext context, MathPuzzleBloc bloc) {
    return <Widget>[
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == Route.puzzle) {
            bloc.resetSession();
          } else {
            Navigator.pushNamed(context, value);
          }},
        itemBuilder: (buildContext) {
          return [
            PopupMenuItem<String>(
              value: Route.puzzle,
              child: ListTile(
                leading: Icon(Icons.article_outlined),
                title: Text(AppLocalizations.of(context).newSessionMenu),
              ),
            ),
            PopupMenuItem<String>(
              value: Route.settings,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context).settingsMenu),
              ),
            ),
          ];
        },
      )
    ];
  }
}


