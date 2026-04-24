import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../providers/app_providers.dart';
import '../game/game_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/game_models.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(l10n.levelSelect),
        backgroundColor: AppColors.darkBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildDifficultyTabs(l10n),
          const SizedBox(height: AppSizes.md),
          Expanded(child: _buildLevelGrid(context, l10n)),
        ],
      ),
    );
  }

  Widget _buildDifficultyTabs(AppLocalizations l10n) {
    final difficulties = [
      (Difficulty.easy, l10n.easy, AppColors.neonGreen),
      (Difficulty.medium, l10n.medium, AppColors.neonYellow),
      (Difficulty.hard, l10n.hard, AppColors.neonRed),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
      child: Row(
        children: difficulties.map((d) {
          final isSelected = _selectedDifficulty == d.$1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => setState(() => _selectedDifficulty = d.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(
                      color: isSelected ? d.$3 : d.$3.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected ? d.$3.withOpacity(0.2) : Colors.transparent,
                    boxShadow: isSelected
                        ? [BoxShadow(color: d.$3.withOpacity(0.3), blurRadius: 12)]
                        : null,
                  ),
                  child: Text(
                    d.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? d.$3 : d.$3.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLevelGrid(BuildContext context, AppLocalizations l10n) {
    final levelProvider = context.watch<LevelProvider>();
    const displayCount = 50; // Show first 50 levels

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: displayCount,
      itemBuilder: (context, index) {
        final progress = levelProvider.getLevelProgress(_selectedDifficulty, index);
        return _LevelCell(
          index: index,
          progress: progress,
          difficulty: _selectedDifficulty,
          onTap: progress.isUnlocked
              ? () => _startLevel(context, index)
              : null,
        ).animate().fadeIn(duration: 300.ms, delay: (index * 20).ms);
      },
    );
  }

  void _startLevel(BuildContext context, int levelIndex) {
    final livesProvider = context.read<LivesProvider>();
    if (!livesProvider.hasLives) {
      _showOutOfLivesDialog(context);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          difficulty: _selectedDifficulty,
          levelIndex: levelIndex,
        ),
      ),
    );
  }

  void _showOutOfLivesDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: const BorderSide(color: AppColors.neonRed, width: 2),
        ),
        title: NeonText(text: l10n.outOfLives, color: AppColors.neonRed, fontSize: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeartsWidget(lives: 0),
            const SizedBox(height: AppSizes.md),
            NeonButton(
              text: l10n.watchAd,
              color: AppColors.neonGreen,
              onTap: () {
                Navigator.pop(ctx);
                context.read<LivesProvider>().refillLives();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.back, style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _LevelCell extends StatelessWidget {
  final int index;
  final LevelProgress progress;
  final Difficulty difficulty;
  final VoidCallback? onTap;

  const _LevelCell({
    required this.index,
    required this.progress,
    required this.difficulty,
    this.onTap,
  });

  Color get _difficultyColor {
    switch (difficulty) {
      case Difficulty.easy: return AppColors.neonGreen;
      case Difficulty.medium: return AppColors.neonYellow;
      case Difficulty.hard: return AppColors.neonRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = progress.isUnlocked;
    final color = isUnlocked ? _difficultyColor : AppColors.textDim;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: isUnlocked ? color.withOpacity(0.7) : AppColors.textDim.withOpacity(0.2),
            width: progress.stars > 0 ? 2 : 1,
          ),
          color: isUnlocked
              ? color.withOpacity(0.08)
              : AppColors.darkCard.withOpacity(0.3),
          boxShadow: progress.stars > 0
              ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              Icon(Icons.lock, color: AppColors.textDim.withOpacity(0.4), size: 20)
            else
              Text(
                '${index + 1}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  shadows: [Shadow(color: color.withOpacity(0.6), blurRadius: 6)],
                ),
              ),
            if (isUnlocked && progress.stars > 0) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Icon(
                  i < progress.stars ? Icons.star : Icons.star_outline,
                  size: 10,
                  color: i < progress.stars ? AppColors.starGold : AppColors.textDim,
                )),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
