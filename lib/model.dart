import 'package:flutter/foundation.dart';
import 'package:math_puzzles/puzzle.dart';

class PuzzleModel extends ChangeNotifier {
  Puzzle _puzzle;
  bool _puzzleAnswered;

  PuzzleModel(this._puzzle) : _puzzleAnswered = false;

  bool get puzzleAnswered => _puzzleAnswered;

  set puzzleAnswered(bool value) {
    _puzzleAnswered = value;
    notifyListeners();
  }

  Puzzle get puzzle => _puzzle;

  set puzzle(Puzzle newPuzzle) {
    _puzzle = newPuzzle;
    _puzzleAnswered = false;
    notifyListeners();
  }
}
