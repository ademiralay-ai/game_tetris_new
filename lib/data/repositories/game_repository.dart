import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import '../../core/constants/app_constants.dart';

class GameRepository {
  final SharedPreferences _prefs;

  GameRepository(this._prefs);

  // Lives
  int get lives => _prefs.getInt(AppConstants.keyLives) ?? AppConstants.maxLives;

  Future<void> setLives(int lives) async {
    await _prefs.setInt(AppConstants.keyLives, lives.clamp(0, AppConstants.maxLives));
  }

  Future<void> decrementLife() async {
    await setLives(lives - 1);
  }

  Future<void> refillLives() async {
    await setLives(AppConstants.maxLives);
  }

  // High Score
  int get highScore => _prefs.getInt(AppConstants.keyHighScore) ?? 0;

  Future<void> updateHighScore(int score) async {
    if (score > highScore) {
      await _prefs.setInt(AppConstants.keyHighScore, score);
    }
  }

  // Settings
  String get language => _prefs.getString(AppConstants.keyLanguage) ?? 'tr';
  Future<void> setLanguage(String lang) async => _prefs.setString(AppConstants.keyLanguage, lang);

  bool get musicEnabled => _prefs.getBool(AppConstants.keyMusicEnabled) ?? true;
  Future<void> setMusicEnabled(bool v) async => _prefs.setBool(AppConstants.keyMusicEnabled, v);

  bool get sfxEnabled => _prefs.getBool(AppConstants.keySfxEnabled) ?? true;
  Future<void> setSfxEnabled(bool v) async => _prefs.setBool(AppConstants.keySfxEnabled, v);

  bool get vibrationEnabled => _prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;
  Future<void> setVibrationEnabled(bool v) async => _prefs.setBool(AppConstants.keyVibrationEnabled, v);

  String get themeMode => _prefs.getString(AppConstants.keyThemeMode) ?? 'dark';
  Future<void> setThemeMode(String mode) async => _prefs.setString(AppConstants.keyThemeMode, mode);

  // Level progress
  LevelProgress getLevelProgress(Difficulty difficulty, int levelIndex) {
    final key = '${AppConstants.keyLevelProgress}_${difficulty.index}_$levelIndex';
    final data = _prefs.getString(key);
    if (data == null) {
      return LevelProgress(
        levelIndex: levelIndex,
        stars: 0,
        highScore: 0,
        isUnlocked: levelIndex == 0,
      );
    }
    return LevelProgress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  Future<void> saveLevelProgress(Difficulty difficulty, LevelProgress progress) async {
    final key = '${AppConstants.keyLevelProgress}_${difficulty.index}_${progress.levelIndex}';
    await _prefs.setString(key, json.encode(progress.toMap()));
    // Unlock next level
    if (progress.stars > 0 && progress.levelIndex + 1 < AppConstants.levelsPerDifficulty) {
      final nextKey = '${AppConstants.keyLevelProgress}_${difficulty.index}_${progress.levelIndex + 1}';
      final nextData = _prefs.getString(nextKey);
      if (nextData == null) {
        final nextProgress = LevelProgress(
          levelIndex: progress.levelIndex + 1,
          stars: 0,
          highScore: 0,
          isUnlocked: true,
        );
        await _prefs.setString(nextKey, json.encode(nextProgress.toMap()));
      } else {
        final nextProgress = LevelProgress.fromMap(json.decode(nextData) as Map<String, dynamic>);
        if (!nextProgress.isUnlocked) {
          await _prefs.setString(nextKey, json.encode(nextProgress.copyWith(isUnlocked: true).toMap()));
        }
      }
    }
  }

  // Game records
  List<GameRecord> get gameRecords {
    final data = _prefs.getStringList('game_records') ?? [];
    return data.map((e) => GameRecord.fromMap(json.decode(e) as Map<String, dynamic>)).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  Future<void> addGameRecord(GameRecord record) async {
    final records = gameRecords;
    records.add(record);
    records.sort((a, b) => b.score.compareTo(a.score));
    final limited = records.take(50).toList();
    await _prefs.setStringList('game_records', limited.map((e) => json.encode(e.toMap())).toList());
  }

  int get totalGamesPlayed => _prefs.getInt(AppConstants.keyTotalGamesPlayed) ?? 0;

  Future<void> incrementGamesPlayed() async {
    await _prefs.setInt(AppConstants.keyTotalGamesPlayed, totalGamesPlayed + 1);
  }
}
