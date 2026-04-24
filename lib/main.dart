import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/game_repository.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'services/admob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AdMob (no-op on web)
  await AdMobService().initialize();

  final prefs = await SharedPreferences.getInstance();
  final repository = GameRepository(prefs);

  runApp(
    MultiProvider(
      providers: [
        Provider<GameRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => SettingsProvider(repository)),
        ChangeNotifierProvider(create: (_) => LivesProvider(repository)),
        ChangeNotifierProvider(create: (_) => LevelProvider(repository)),
      ],
      child: const NeonTetrisApp(),
    ),
  );
}

class NeonTetrisApp extends StatelessWidget {
  const NeonTetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Neon Tetris',
      debugShowCheckedModeBanner: false,
      theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      locale: Locale(settings.language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
