import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/game_models.dart';
import '../../core/constants/app_constants.dart';

enum GameState { idle, playing, paused, gameOver, levelComplete }

class GameEngine {
  static const int boardWidth = AppSizes.boardWidth;
  static const int boardHeight = AppSizes.boardHeight;

  // Board: null = empty, Color = filled
  List<List<Color?>> board = List.generate(boardHeight, (_) => List.filled(boardWidth, null));
  Tetromino? currentPiece;
  Tetromino? nextPiece;
  Tetromino? heldPiece;
  bool canHold = true;

  int score = 0;
  int linesCleared = 0;
  int level = 1;
  int combo = 0;

  GameState state = GameState.idle;
  final Random _rng = Random();

  final List<TetrominoType> _bag = [];

  void init() {
    board = List.generate(boardHeight, (_) => List.filled(boardWidth, null));
    score = 0;
    linesCleared = 0;
    level = 1;
    combo = 0;
    canHold = true;
    _bag.clear();
    state = GameState.playing;
    _spawnNext();
    _spawnNext();
  }

  void _fillBag() {
    _bag.addAll(TetrominoType.values);
    _bag.shuffle(_rng);
  }

  TetrominoType _nextFromBag() {
    if (_bag.isEmpty) _fillBag();
    return _bag.removeLast();
  }

  void _spawnNext() {
    currentPiece = nextPiece;
    nextPiece = Tetromino.fromType(_nextFromBag());
    currentPiece ??= Tetromino.fromType(_nextFromBag());
    canHold = true;
    if (!_isValidPosition(currentPiece!)) {
      state = GameState.gameOver;
    }
  }

  bool _isValidPosition(Tetromino piece, {int? rowOffset, int? colOffset}) {
    final ro = rowOffset ?? 0;
    final co = colOffset ?? 0;
    for (final cell in piece.cells) {
      final r = cell.row + ro;
      final c = cell.col + co;
      if (r < 0 || r >= boardHeight || c < 0 || c >= boardWidth) return false;
      if (board[r][c] != null) return false;
    }
    return true;
  }

  bool moveLeft() {
    if (currentPiece == null || state != GameState.playing) return false;
    if (_isValidPosition(currentPiece!, colOffset: -1)) {
      currentPiece = currentPiece!.copyWith(col: currentPiece!.col - 1);
      return true;
    }
    return false;
  }

  bool moveRight() {
    if (currentPiece == null || state != GameState.playing) return false;
    if (_isValidPosition(currentPiece!, colOffset: 1)) {
      currentPiece = currentPiece!.copyWith(col: currentPiece!.col + 1);
      return true;
    }
    return false;
  }

  bool softDrop() {
    if (currentPiece == null || state != GameState.playing) return false;
    if (_isValidPosition(currentPiece!, rowOffset: 1)) {
      currentPiece = currentPiece!.copyWith(row: currentPiece!.row + 1);
      score += AppConstants.scoreSoftDrop;
      return true;
    }
    _lockPiece();
    return false;
  }

  int hardDrop() {
    if (currentPiece == null || state != GameState.playing) return 0;
    int dropped = 0;
    while (_isValidPosition(currentPiece!, rowOffset: 1)) {
      currentPiece = currentPiece!.copyWith(row: currentPiece!.row + 1);
      dropped++;
    }
    score += dropped * AppConstants.scoreHardDrop;
    _lockPiece();
    return dropped;
  }

  bool rotate({bool clockwise = true}) {
    if (currentPiece == null || state != GameState.playing) return false;
    final nextRot = clockwise
        ? (currentPiece!.rotationIndex + 1) % 4
        : (currentPiece!.rotationIndex + 3) % 4;
    final rotated = currentPiece!.copyWith(rotationIndex: nextRot);

    // Wall kick attempts
    final kicks = [0, -1, 1, -2, 2];
    for (final kick in kicks) {
      if (_isValidPosition(rotated, colOffset: kick)) {
        currentPiece = rotated.copyWith(col: rotated.col + kick);
        return true;
      }
    }
    return false;
  }

  void holdPiece() {
    if (!canHold || currentPiece == null || state != GameState.playing) return;
    canHold = false;
    if (heldPiece == null) {
      heldPiece = Tetromino.fromType(currentPiece!.type);
      _spawnNext();
    } else {
      final temp = heldPiece;
      heldPiece = Tetromino.fromType(currentPiece!.type);
      currentPiece = Tetromino.fromType(temp!.type);
    }
  }

  Tetromino? get ghostPiece {
    if (currentPiece == null) return null;
    var ghost = currentPiece!.copyWith();
    while (_isValidPosition(ghost, rowOffset: 1)) {
      ghost = ghost.copyWith(row: ghost.row + 1);
    }
    return ghost;
  }

  void _lockPiece() {
    if (currentPiece == null) return;
    for (final cell in currentPiece!.cells) {
      if (cell.row >= 0 && cell.row < boardHeight && cell.col >= 0 && cell.col < boardWidth) {
        board[cell.row][cell.col] = currentPiece!.color;
      }
    }
    final cleared = _clearLines();
    _updateScore(cleared);
    _spawnNext();
  }

  int _clearLines() {
    int cleared = 0;
    for (int r = boardHeight - 1; r >= 0; r--) {
      if (board[r].every((c) => c != null)) {
        board.removeAt(r);
        board.insert(0, List.filled(boardWidth, null));
        cleared++;
        r++; // recheck same row
      }
    }
    return cleared;
  }

  void _updateScore(int cleared) {
    if (cleared == 0) {
      combo = 0;
      return;
    }
    linesCleared += cleared;
    combo++;
    int lineScore = 0;
    switch (cleared) {
      case 1: lineScore = AppConstants.score1Line; break;
      case 2: lineScore = AppConstants.score2Lines; break;
      case 3: lineScore = AppConstants.score3Lines; break;
      default: lineScore = AppConstants.score4Lines; break;
    }
    lineScore *= level;
    if (combo > 1) lineScore = (lineScore * (1 + (combo - 1) * 0.5)).round();
    score += lineScore;

    level = (linesCleared ~/ 10) + 1;
  }

  bool tick() {
    if (state != GameState.playing) return false;
    return softDrop();
  }

  void pause() {
    if (state == GameState.playing) state = GameState.paused;
  }

  void resume() {
    if (state == GameState.paused) state = GameState.playing;
  }

  int get dropSpeed {
    final base = AppConstants.easySpeed;
    final decrease = (level - 1) * AppConstants.speedIncreasePerLevel;
    return (base - decrease).clamp(100, base);
  }

  int calculateStars(int clearedLines) {
    if (clearedLines >= AppConstants.star3Threshold) return 3;
    if (clearedLines >= AppConstants.star2Threshold) return 2;
    if (clearedLines >= AppConstants.star1Threshold) return 1;
    return 0;
  }
}
