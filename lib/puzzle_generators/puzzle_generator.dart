import '../data/puzzle.dart';

abstract class PuzzleGenerator {
  const PuzzleGenerator();

  Puzzle generate(Map<String, Object> parameters);

  T getRequiredParameter<T>(String name, Map<String, Object> parameters) {
    if (parameters.containsKey(name)) {
      return parameters[name] as T;
    } else {
      throw Exception('Required parameter "$name" not provided.');
    }
  }
}