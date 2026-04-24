import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../providers/app_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/game_models.dart';
import 'package:intl/intl.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levelProvider = context.watch<LevelProvider>();
    final records = levelProvider.gameRecords;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(l10n.records),
        backgroundColor: AppColors.darkBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSummaryCards(context, l10n, levelProvider),
          const NeonDivider(),
          const SizedBox(height: AppSizes.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: NeonText(text: l10n.bestScores, fontSize: 16, color: AppColors.neonCyan),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.leaderboard_outlined, color: AppColors.textDim, size: 48),
                        const SizedBox(height: AppSizes.md),
                        Text(l10n.noRecords, style: const TextStyle(color: AppColors.textDim)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return _RecordTile(
                        record: records[index],
                        rank: index + 1,
                      ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, AppLocalizations l10n, LevelProvider levelProvider) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        children: [
          Expanded(
            child: NeonContainer(
              borderColor: AppColors.neonYellow,
              child: Column(
                children: [
                  Icon(Icons.emoji_events, color: AppColors.starGold, size: 28,
                    shadows: [Shadow(color: AppColors.starGold.withOpacity(0.8), blurRadius: 8)]),
                  const SizedBox(height: AppSizes.xs),
                  Text(l10n.highScore, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1)),
                  NeonText(
                    text: levelProvider.highScore.toString(),
                    color: AppColors.neonYellow,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: NeonContainer(
              borderColor: AppColors.neonGreen,
              child: Column(
                children: [
                  Icon(Icons.sports_esports, color: AppColors.neonGreen, size: 28,
                    shadows: [Shadow(color: AppColors.neonGreen.withOpacity(0.8), blurRadius: 8)]),
                  const SizedBox(height: AppSizes.xs),
                  Text(l10n.totalGames, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1)),
                  NeonText(
                    text: levelProvider.totalGamesPlayed.toString(),
                    color: AppColors.neonGreen,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final GameRecord record;
  final int rank;

  const _RecordTile({required this.record, required this.rank});

  Color get _rankColor {
    switch (rank) {
      case 1: return AppColors.starGold;
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFCD7F32);
      default: return AppColors.textDim;
    }
  }

  Color get _diffColor {
    switch (record.difficulty) {
      case Difficulty.easy: return AppColors.neonGreen;
      case Difficulty.medium: return AppColors.neonYellow;
      case Difficulty.hard: return AppColors.neonRed;
    }
  }

  String get _diffLabel {
    switch (record.difficulty) {
      case Difficulty.easy: return 'E';
      case Difficulty.medium: return 'M';
      case Difficulty.hard: return 'H';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(
          color: rank <= 3 ? _rankColor.withOpacity(0.5) : AppColors.textDim.withOpacity(0.2),
        ),
        color: AppColors.darkCard,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: TextStyle(color: _rankColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _diffColor.withOpacity(0.2),
              border: Border.all(color: _diffColor, width: 1),
            ),
            child: Center(
              child: Text(_diffLabel, style: TextStyle(color: _diffColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeonText(text: record.score.toString(), fontSize: 18, color: AppColors.neonCyan),
                Text(
                  'Lv.${record.level} | Lines: ${record.linesCleared}',
                  style: const TextStyle(color: AppColors.textDim, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('MM/dd').format(record.date),
            style: const TextStyle(color: AppColors.textDim, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
