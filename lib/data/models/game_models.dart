import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

enum TetrominoType { I, O, T, S, Z, J, L }
enum Difficulty { easy, medium, hard }

class Position {
  final int row;
  final int col;
  const Position(this.row, this.col);
}

class Tetromino {
  final TetrominoType type;
  final List<List<List<int>>> rotations;
  final Color color;
  int rotationIndex;
  int row;
  int col;

  Tetromino({
    required this.type,
    required this.rotations,
    required this.color,
    this.rotationIndex = 0,
    this.row = 0,
    this.col = 3,
  });

  List<List<int>> get currentShape => rotations[rotationIndex];

  List<Position> get cells {
    final List<Position> result = [];
    for (int r = 0; r < currentShape.length; r++) {
      for (int c = 0; c < currentShape[r].length; c++) {
        if (currentShape[r][c] == 1) {
          result.add(Position(row + r, col + c));
        }
      }
    }
    return result;
  }

  Tetromino copyWith({int? rotationIndex, int? row, int? col}) {
    return Tetromino(
      type: type,
      rotations: rotations,
      color: color,
      rotationIndex: rotationIndex ?? this.rotationIndex,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  static Tetromino fromType(TetrominoType type) {
    switch (type) {
      case TetrominoType.I:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoI,
          rotations: [
            [[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]],
            [[0,0,1,0],[0,0,1,0],[0,0,1,0],[0,0,1,0]],
            [[0,0,0,0],[0,0,0,0],[1,1,1,1],[0,0,0,0]],
            [[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]],
          ],
          row: 0,
          col: 3,
        );
      case TetrominoType.O:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoO,
          rotations: [
            [[1,1],[1,1]],
            [[1,1],[1,1]],
            [[1,1],[1,1]],
            [[1,1],[1,1]],
          ],
          row: 0,
          col: 4,
        );
      case TetrominoType.T:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoT,
          rotations: [
            [[0,1,0],[1,1,1],[0,0,0]],
            [[0,1,0],[0,1,1],[0,1,0]],
            [[0,0,0],[1,1,1],[0,1,0]],
            [[0,1,0],[1,1,0],[0,1,0]],
          ],
          row: 0,
          col: 3,
        );
      case TetrominoType.S:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoS,
          rotations: [
            [[0,1,1],[1,1,0],[0,0,0]],
            [[0,1,0],[0,1,1],[0,0,1]],
            [[0,0,0],[0,1,1],[1,1,0]],
            [[1,0,0],[1,1,0],[0,1,0]],
          ],
          row: 0,
          col: 3,
        );
      case TetrominoType.Z:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoZ,
          rotations: [
            [[1,1,0],[0,1,1],[0,0,0]],
            [[0,0,1],[0,1,1],[0,1,0]],
            [[0,0,0],[1,1,0],[0,1,1]],
            [[0,1,0],[1,1,0],[1,0,0]],
          ],
          row: 0,
          col: 3,
        );
      case TetrominoType.J:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoJ,
          rotations: [
            [[1,0,0],[1,1,1],[0,0,0]],
            [[0,1,1],[0,1,0],[0,1,0]],
            [[0,0,0],[1,1,1],[0,0,1]],
            [[0,1,0],[0,1,0],[1,1,0]],
          ],
          row: 0,
          col: 3,
        );
      case TetrominoType.L:
        return Tetromino(
          type: type,
          color: AppColors.tetrominoL,
          rotations: [
            [[0,0,1],[1,1,1],[0,0,0]],
            [[0,1,0],[0,1,0],[0,1,1]],
            [[0,0,0],[1,1,1],[1,0,0]],
            [[1,1,0],[0,1,0],[0,1,0]],
          ],
          row: 0,
          col: 3,
        );
    }
  }
}

class LevelProgress {
  final int levelIndex;
  final int stars;
  final int highScore;
  final bool isUnlocked;

  const LevelProgress({
    required this.levelIndex,
    required this.stars,
    required this.highScore,
    required this.isUnlocked,
  });

  LevelProgress copyWith({int? stars, int? highScore, bool? isUnlocked}) {
    return LevelProgress(
      levelIndex: levelIndex,
      stars: stars ?? this.stars,
      highScore: highScore ?? this.highScore,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toMap() => {
    'levelIndex': levelIndex,
    'stars': stars,
    'highScore': highScore,
    'isUnlocked': isUnlocked,
  };

  factory LevelProgress.fromMap(Map<String, dynamic> map) => LevelProgress(
    levelIndex: map['levelIndex'] as int,
    stars: map['stars'] as int,
    highScore: map['highScore'] as int,
    isUnlocked: map['isUnlocked'] as bool,
  );
}

class GameRecord {
  final DateTime date;
  final int score;
  final int linesCleared;
  final int level;
  final Difficulty difficulty;

  const GameRecord({
    required this.date,
    required this.score,
    required this.linesCleared,
    required this.level,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'score': score,
    'linesCleared': linesCleared,
    'level': level,
    'difficulty': difficulty.index,
  };

  factory GameRecord.fromMap(Map<String, dynamic> map) => GameRecord(
    date: DateTime.parse(map['date'] as String),
    score: map['score'] as int,
    linesCleared: map['linesCleared'] as int,
    level: map['level'] as int,
    difficulty: Difficulty.values[map['difficulty'] as int],
  );
}
