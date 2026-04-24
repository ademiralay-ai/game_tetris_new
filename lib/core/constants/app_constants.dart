import 'package:flutter/material.dart';

class AppColors {
  // Neon colors
  static const neonCyan = Color(0xFF00FFFF);
  static const neonMagenta = Color(0xFFFF00FF);
  static const neonGreen = Color(0xFF39FF14);
  static const neonYellow = Color(0xFFFFFF00);
  static const neonOrange = Color(0xFFFF6600);
  static const neonBlue = Color(0xFF0066FF);
  static const neonPurple = Color(0xFF9900FF);
  static const neonRed = Color(0xFFFF0044);
  static const neonPink = Color(0xFFFF0099);

  // Dark backgrounds
  static const darkBg = Color(0xFF0A0A0F);
  static const darkBg2 = Color(0xFF0D0D1A);
  static const darkBg3 = Color(0xFF111122);
  static const darkCard = Color(0xFF1A1A2E);
  static const darkCardLight = Color(0xFF16213E);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0CC);
  static const textDim = Color(0xFF606080);

  // Tetromino colors (neon)
  static const tetrominoI = Color(0xFF00FFFF); // Cyan
  static const tetrominoO = Color(0xFFFFFF00); // Yellow
  static const tetrominoT = Color(0xFFCC00FF); // Purple
  static const tetrominoS = Color(0xFF39FF14); // Green
  static const tetrominoZ = Color(0xFFFF0044); // Red
  static const tetrominoJ = Color(0xFF0066FF); // Blue
  static const tetrominoL = Color(0xFFFF6600); // Orange
  static const tetrominoGhost = Color(0x33FFFFFF); // Ghost (semi-transparent white)
  static const tetrominoEmpty = Color(0xFF0D0D1A); // Empty cell

  // UI elements
  static const borderNeon = Color(0xFF00FFFF);
  static const starGold = Color(0xFFFFD700);
  static const heartRed = Color(0xFFFF0044);
  static const heartEmpty = Color(0xFF333355);
}

class AppSizes {
  static const boardWidth = 10;
  static const boardHeight = 20;
  static const cellSize = 32.0;
  static const boardPadding = 4.0;

  static const splashLogoSize = 120.0;

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 50.0;
}

class AppConstants {
  static const appName = 'Neon Tetris';
  static const appVersion = '1.0.0';
  static const developerName = 'Abdullah Demiralay';
  static const developerEmail = 'abdullahdemiralay@gmail.com';
  static const organization = 'Saggio Ai';

  static const int levelsPerDifficulty = 1000;
  static const int maxLives = 3;

  // Speeds (milliseconds per drop tick)
  static const int easySpeed = 800;
  static const int mediumSpeed = 500;
  static const int hardSpeed = 250;
  static const int speedIncreasePerLevel = 5; // ms decrease per level

  // Scoring
  static const int score1Line = 100;
  static const int score2Lines = 300;
  static const int score3Lines = 500;
  static const int score4Lines = 800;
  static const int scoreSoftDrop = 1;
  static const int scoreHardDrop = 2;

  // Stars thresholds (line clears per level)
  static const int star1Threshold = 3;
  static const int star2Threshold = 7;
  static const int star3Threshold = 12;

  // SharedPreferences keys
  static const String keyHighScore = 'high_score';
  static const String keyLives = 'lives';
  static const String keyLanguage = 'language';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keySfxEnabled = 'sfx_enabled';
  static const String keyVibrationEnabled = 'vibration_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLevelProgress = 'level_progress';
  static const String keyLevelStars = 'level_stars';
  static const String keyLevelHighScores = 'level_high_scores';
  static const String keyTotalGamesPlayed = 'total_games_played';
  static const String keyLastLivesRefill = 'last_lives_refill';

  // AdMob (Test IDs)
  static const String bannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
}
