import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../providers/app_providers.dart';
import '../level_select/level_select_screen.dart';
import '../records/records_screen.dart';
import '../settings/settings_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final livesProvider = context.watch<LivesProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, l10n, livesProvider),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTitle(),
                          const SizedBox(height: AppSizes.xxl),
                          _buildMenuButtons(context, l10n),
                          const SizedBox(height: AppSizes.xl),
                          _buildHighScore(context, l10n),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return CustomPaint(
      painter: _HomeBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, LivesProvider livesProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeartsWidget(lives: livesProvider.lives),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.neonCyan),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        NeonText(
          text: 'NEON',
          fontSize: 48,
          color: AppColors.neonCyan,
          blurRadius: 20,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0),
        NeonText(
          text: 'TETRIS',
          fontSize: 48,
          color: AppColors.neonMagenta,
          blurRadius: 20,
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, AppLocalizations l10n) {
    final buttons = [
      _MenuButton(
        label: l10n.play,
        color: AppColors.neonGreen,
        icon: Icons.play_arrow_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
        ),
        delay: 200,
      ),
      _MenuButton(
        label: l10n.levels,
        color: AppColors.neonCyan,
        icon: Icons.grid_view_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
        ),
        delay: 300,
      ),
      _MenuButton(
        label: l10n.records,
        color: AppColors.neonYellow,
        icon: Icons.leaderboard_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecordsScreen()),
        ),
        delay: 400,
      ),
      _MenuButton(
        label: l10n.settings,
        color: AppColors.neonPurple,
        icon: Icons.settings_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
        delay: 500,
      ),
    ];

    return Column(
      children: buttons.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.md),
        child: NeonButton(
          text: b.label,
          color: b.color,
          icon: b.icon,
          width: 260,
          onTap: b.onTap,
        ).animate().fadeIn(duration: 400.ms, delay: b.delay.ms).slideX(begin: -0.2, end: 0),
      )).toList(),
    );
  }

  Widget _buildHighScore(BuildContext context, AppLocalizations l10n) {
    final levelProvider = context.watch<LevelProvider>();
    return NeonContainer(
      borderColor: AppColors.neonYellow,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, color: AppColors.starGold, size: 24,
            shadows: [Shadow(color: AppColors.starGold.withOpacity(0.8), blurRadius: 8)]),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.highScore,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 1)),
              NeonText(
                text: levelProvider.highScore.toString().padLeft(7, '0'),
                fontSize: 22,
                color: AppColors.neonYellow,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 700.ms);
  }
}

class _MenuButton {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final int delay;

  _MenuButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
    required this.delay,
  });
}

class _HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Neon corner accents
    final accentPaint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const accentLen = 40.0;

    // Top-left
    canvas.drawLine(const Offset(20, 20), const Offset(20 + accentLen, 20), accentPaint);
    canvas.drawLine(const Offset(20, 20), const Offset(20, 20 + accentLen), accentPaint);
    // Top-right
    canvas.drawLine(Offset(size.width - 20, 20), Offset(size.width - 20 - accentLen, 20), accentPaint);
    canvas.drawLine(Offset(size.width - 20, 20), Offset(size.width - 20, 20 + accentLen), accentPaint);
    // Bottom-left
    canvas.drawLine(Offset(20, size.height - 20), Offset(20 + accentLen, size.height - 20), accentPaint);
    canvas.drawLine(Offset(20, size.height - 20), Offset(20, size.height - 20 - accentLen), accentPaint);
    // Bottom-right
    canvas.drawLine(Offset(size.width - 20, size.height - 20), Offset(size.width - 20 - accentLen, size.height - 20), accentPaint);
    canvas.drawLine(Offset(size.width - 20, size.height - 20), Offset(size.width - 20, size.height - 20 - accentLen), accentPaint);
  }

  @override
  bool shouldRepaint(_HomeBackgroundPainter old) => false;
}
