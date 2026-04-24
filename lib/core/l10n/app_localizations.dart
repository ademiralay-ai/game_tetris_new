import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      'app_name': 'Neon Tetris',
      'play': 'OYNA',
      'levels': 'SEVİYELER',
      'records': 'REKORLAR',
      'settings': 'AYARLAR',
      'easy': 'Kolay',
      'medium': 'Orta',
      'hard': 'Zor',
      'score': 'Skor',
      'level': 'Seviye',
      'lines': 'Satır',
      'next': 'Sonraki',
      'hold': 'Tut',
      'pause': 'Durdur',
      'resume': 'Devam',
      'restart': 'Yeniden',
      'quit': 'Çık',
      'game_over': 'Oyun Bitti',
      'level_complete': 'Seviye Tamamlandı!',
      'new_record': 'Yeni Rekor!',
      'paused': 'DURAKLATILDI',
      'lives': 'Can',
      'out_of_lives': 'Can Kalmadı!',
      'watch_ad': 'Reklam İzle +3 Can',
      'continue_watching': 'Devam Et',
      'back': 'Geri',
      'language': 'Dil',
      'music': 'Müzik',
      'sound_effects': 'Ses Efektleri',
      'vibration': 'Titreşim',
      'theme': 'Tema',
      'dark_theme': 'Karanlık',
      'light_theme': 'Açık',
      'version': 'Versiyon',
      'developer': 'Geliştirici',
      'contact': 'İletişim',
      'share_app': 'Arkadaşlarına Öner',
      'share_message': 'Neon Tetris oynuyorum! Sen de indir: ',
      'high_score': 'En Yüksek Skor',
      'total_games': 'Toplam Oyun',
      'best_scores': 'En İyi Skorlar',
      'no_records': 'Henüz kayıt yok',
      'stars': 'Yıldız',
      'locked': 'Kilitli',
      'combo': 'Kombo',
      'hard_drop_hint': 'Hızlı Düşür',
      'rotate_hint': 'Döndür',
      'move_hint': 'Hareket',
      'level_select': 'Seviye Seç',
      'difficulty_select': 'Zorluk Seç',
      'select_level': 'Seviye Seçin',
      'tap_to_start': 'Başlamak için dokun',
      'get_ready': 'Hazır Ol!',
      'best': 'En İyi',
      'home': 'Ana Menü',
      'turkish': 'Türkçe',
      'english': 'English',
    },
    'en': {
      'app_name': 'Neon Tetris',
      'play': 'PLAY',
      'levels': 'LEVELS',
      'records': 'RECORDS',
      'settings': 'SETTINGS',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'score': 'Score',
      'level': 'Level',
      'lines': 'Lines',
      'next': 'Next',
      'hold': 'Hold',
      'pause': 'Pause',
      'resume': 'Resume',
      'restart': 'Restart',
      'quit': 'Quit',
      'game_over': 'Game Over',
      'level_complete': 'Level Complete!',
      'new_record': 'New Record!',
      'paused': 'PAUSED',
      'lives': 'Lives',
      'out_of_lives': 'Out of Lives!',
      'watch_ad': 'Watch Ad for +3 Lives',
      'continue_watching': 'Continue',
      'back': 'Back',
      'language': 'Language',
      'music': 'Music',
      'sound_effects': 'Sound Effects',
      'vibration': 'Vibration',
      'theme': 'Theme',
      'dark_theme': 'Dark',
      'light_theme': 'Light',
      'version': 'Version',
      'developer': 'Developer',
      'contact': 'Contact',
      'share_app': 'Recommend to Friends',
      'share_message': 'I\'m playing Neon Tetris! Download it: ',
      'high_score': 'High Score',
      'total_games': 'Total Games',
      'best_scores': 'Best Scores',
      'no_records': 'No records yet',
      'stars': 'Stars',
      'locked': 'Locked',
      'combo': 'Combo',
      'hard_drop_hint': 'Hard Drop',
      'rotate_hint': 'Rotate',
      'move_hint': 'Move',
      'level_select': 'Select Level',
      'difficulty_select': 'Select Difficulty',
      'select_level': 'Select Level',
      'tap_to_start': 'Tap to start',
      'get_ready': 'Get Ready!',
      'best': 'Best',
      'home': 'Home',
      'turkish': 'Türkçe',
      'english': 'English',
    },
  };

  String get appName => _get('app_name');
  String get play => _get('play');
  String get levels => _get('levels');
  String get records => _get('records');
  String get settings => _get('settings');
  String get easy => _get('easy');
  String get medium => _get('medium');
  String get hard => _get('hard');
  String get score => _get('score');
  String get level => _get('level');
  String get lines => _get('lines');
  String get next => _get('next');
  String get hold => _get('hold');
  String get pause => _get('pause');
  String get resume => _get('resume');
  String get restart => _get('restart');
  String get quit => _get('quit');
  String get gameOver => _get('game_over');
  String get levelComplete => _get('level_complete');
  String get newRecord => _get('new_record');
  String get paused => _get('paused');
  String get lives => _get('lives');
  String get outOfLives => _get('out_of_lives');
  String get watchAd => _get('watch_ad');
  String get continueWatching => _get('continue_watching');
  String get back => _get('back');
  String get language => _get('language');
  String get music => _get('music');
  String get soundEffects => _get('sound_effects');
  String get vibration => _get('vibration');
  String get theme => _get('theme');
  String get darkTheme => _get('dark_theme');
  String get lightTheme => _get('light_theme');
  String get version => _get('version');
  String get developer => _get('developer');
  String get contact => _get('contact');
  String get shareApp => _get('share_app');
  String get shareMessage => _get('share_message');
  String get highScore => _get('high_score');
  String get totalGames => _get('total_games');
  String get bestScores => _get('best_scores');
  String get noRecords => _get('no_records');
  String get stars => _get('stars');
  String get locked => _get('locked');
  String get combo => _get('combo');
  String get levelSelect => _get('level_select');
  String get difficultySelect => _get('difficulty_select');
  String get tapToStart => _get('tap_to_start');
  String get getReady => _get('get_ready');
  String get best => _get('best');
  String get home => _get('home');
  String get turkish => _get('turkish');
  String get english => _get('english');

  String _get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
           _localizedValues['en']?[key] ??
           key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
