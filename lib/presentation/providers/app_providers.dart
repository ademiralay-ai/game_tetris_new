import 'package:flutter/material.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/models/game_models.dart';
import '../../core/constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  final GameRepository _repo;

  SettingsProvider(this._repo);

  String get language => _repo.language;
  bool get musicEnabled => _repo.musicEnabled;
  bool get sfxEnabled => _repo.sfxEnabled;
  bool get vibrationEnabled => _repo.vibrationEnabled;
  bool get isDarkMode => _repo.themeMode == 'dark';

  Future<void> setLanguage(String lang) async {
    await _repo.setLanguage(lang);
    notifyListeners();
  }

  Future<void> toggleMusic() async {
    await _repo.setMusicEnabled(!musicEnabled);
    notifyListeners();
  }

  Future<void> toggleSfx() async {
    await _repo.setSfxEnabled(!sfxEnabled);
    notifyListeners();
  }

  Future<void> toggleVibration() async {
    await _repo.setVibrationEnabled(!vibrationEnabled);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await _repo.setThemeMode(isDarkMode ? 'light' : 'dark');
    notifyListeners();
  }
}

class LivesProvider extends ChangeNotifier {
  final GameRepository _repo;

  LivesProvider(this._repo);

  int get lives => _repo.lives;
  bool get hasLives => lives > 0;

  Future<void> decrementLife() async {
    await _repo.decrementLife();
    notifyListeners();
  }

  Future<void> refillLives() async {
    await _repo.refillLives();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}

class LevelProvider extends ChangeNotifier {
  final GameRepository _repo;

  LevelProvider(this._repo);

  int get highScore => _repo.highScore;

  LevelProgress getLevelProgress(Difficulty difficulty, int levelIndex) {
    return _repo.getLevelProgress(difficulty, levelIndex);
  }

  Future<void> saveLevelResult({
    required Difficulty difficulty,
    required int levelIndex,
    required int score,
    required int linesCleared,
  }) async {
    final engine = _repo.getLevelProgress(difficulty, levelIndex);
    final stars = _calculateStars(linesCleared);
    final newProgress = engine.copyWith(
      stars: stars > engine.stars ? stars : engine.stars,
      highScore: score > engine.highScore ? score : engine.highScore,
    );
    await _repo.saveLevelProgress(difficulty, newProgress);
    await _repo.updateHighScore(score);
    await _repo.addGameRecord(GameRecord(
      date: DateTime.now(),
      score: score,
      linesCleared: linesCleared,
      level: levelIndex + 1,
      difficulty: difficulty,
    ));
    await _repo.incrementGamesPlayed();
    notifyListeners();
  }

  int _calculateStars(int lines) {
    if (lines >= AppConstants.star3Threshold) return 3;
    if (lines >= AppConstants.star2Threshold) return 2;
    if (lines >= AppConstants.star1Threshold) return 1;
    return 0;
  }

  List<GameRecord> get gameRecords => _repo.gameRecords;
  int get totalGamesPlayed => _repo.totalGamesPlayed;
}
