import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/game_engine.dart';
import '../../data/models/game_models.dart';
import '../../core/constants/app_constants.dart';

class GameProvider extends ChangeNotifier {
  final GameEngine _engine = GameEngine();
  Timer? _gameTimer;
  Difficulty _difficulty = Difficulty.easy;
  int _levelIndex = 0;

  GameEngine get engine => _engine;
  Difficulty get difficulty => _difficulty;
  int get levelIndex => _levelIndex;
  GameState get gameState => _engine.state;
  int get score => _engine.score;
  int get linesCleared => _engine.linesCleared;
  int get level => _engine.level;
  List<List<Color?>> get board => _engine.board;
  Tetromino? get currentPiece => _engine.currentPiece;
  Tetromino? get nextPiece => _engine.nextPiece;
  Tetromino? get heldPiece => _engine.heldPiece;
  Tetromino? get ghostPiece => _engine.ghostPiece;
  bool get canHold => _engine.canHold;
  int get combo => _engine.combo;

  void startGame({required Difficulty difficulty, required int levelIndex}) {
    _difficulty = difficulty;
    _levelIndex = levelIndex;
    _engine.init();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(milliseconds: _getSpeed()), (timer) {
      if (_engine.state == GameState.playing) {
        _engine.tick();
        notifyListeners();
        if (timer.tick % 10 == 0) {
          _restartTimerIfNeeded();
        }
      }
    });
  }

  void _restartTimerIfNeeded() {
    final newSpeed = _getSpeed();
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(milliseconds: newSpeed), (timer) {
      if (_engine.state == GameState.playing) {
        _engine.tick();
        notifyListeners();
      }
    });
  }

  int _getSpeed() {
    final baseSpeed = _difficulty == Difficulty.easy
        ? AppConstants.easySpeed
        : _difficulty == Difficulty.medium
            ? AppConstants.mediumSpeed
            : AppConstants.hardSpeed;
    final levelBonus = (_engine.level - 1) * AppConstants.speedIncreasePerLevel;
    return (baseSpeed - levelBonus).clamp(80, baseSpeed);
  }

  void moveLeft() {
    if (_engine.moveLeft()) notifyListeners();
  }

  void moveRight() {
    if (_engine.moveRight()) notifyListeners();
  }

  void softDrop() {
    _engine.softDrop();
    notifyListeners();
  }

  void hardDrop() {
    _engine.hardDrop();
    notifyListeners();
  }

  void rotate() {
    if (_engine.rotate()) notifyListeners();
  }

  void rotateCounterClockwise() {
    if (_engine.rotate(clockwise: false)) notifyListeners();
  }

  void holdPiece() {
    _engine.holdPiece();
    notifyListeners();
  }

  void pauseGame() {
    _engine.pause();
    notifyListeners();
  }

  void resumeGame() {
    _engine.resume();
    notifyListeners();
  }

  void stopGame() {
    _gameTimer?.cancel();
    _engine.state = GameState.gameOver;
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
