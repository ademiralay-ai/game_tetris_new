import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../providers/app_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppColors.darkBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('GENEL / GENERAL', AppColors.neonCyan),
            const SizedBox(height: AppSizes.md),
            _buildSettingCard(
              context,
              child: Column(
                children: [
                  _buildToggleTile(
                    icon: Icons.music_note,
                    label: l10n.music,
                    value: settings.musicEnabled,
                    color: AppColors.neonGreen,
                    onChanged: (_) => settings.toggleMusic(),
                  ),
                  const NeonDivider(color: AppColors.textDim),
                  _buildToggleTile(
                    icon: Icons.volume_up,
                    label: l10n.soundEffects,
                    value: settings.sfxEnabled,
                    color: AppColors.neonBlue,
                    onChanged: (_) => settings.toggleSfx(),
                  ),
                  const NeonDivider(color: AppColors.textDim),
                  _buildToggleTile(
                    icon: Icons.vibration,
                    label: l10n.vibration,
                    value: settings.vibrationEnabled,
                    color: AppColors.neonOrange,
                    onChanged: (_) => settings.toggleVibration(),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            const SizedBox(height: AppSizes.lg),
            _buildSectionLabel('GÖRÜNÜM / APPEARANCE', AppColors.neonMagenta),
            const SizedBox(height: AppSizes.md),

            _buildSettingCard(
              context,
              child: Column(
                children: [
                  _buildToggleTile(
                    icon: settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    label: l10n.theme,
                    subtitle: settings.isDarkMode ? l10n.darkTheme : l10n.lightTheme,
                    value: settings.isDarkMode,
                    color: AppColors.neonPurple,
                    onChanged: (_) => settings.toggleTheme(),
                  ),
                  const NeonDivider(color: AppColors.textDim),
                  _buildLanguageTile(context, l10n, settings),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

            const SizedBox(height: AppSizes.lg),
            _buildSectionLabel('UYGULAMA / APP', AppColors.neonYellow),
            const SizedBox(height: AppSizes.md),

            _buildSettingCard(
              context,
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.share_outlined,
                    label: l10n.shareApp,
                    color: AppColors.neonGreen,
                    onTap: () => _shareApp(context, l10n),
                  ),
                  const NeonDivider(color: AppColors.textDim),
                  _buildInfoTile(
                    icon: Icons.info_outline,
                    label: l10n.version,
                    value: AppConstants.appVersion,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

            const SizedBox(height: AppSizes.lg),
            _buildDeveloperCard(context, l10n).animate().fadeIn(duration: 300.ms, delay: 400.ms),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color.withOpacity(0.7),
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {required Widget child}) {
    return NeonContainer(
      padding: EdgeInsets.zero,
      borderColor: AppColors.textDim.withOpacity(0.3),
      child: child,
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: AppColors.textDim, fontSize: 11))
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: color,
        activeTrackColor: color.withValues(alpha: 0.3),
        inactiveThumbColor: AppColors.textDim,
        inactiveTrackColor: AppColors.darkCard,
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppLocalizations l10n, SettingsProvider settings) {
    return ListTile(
      leading: const Icon(Icons.language, color: AppColors.neonCyan, size: 22),
      title: Text(l10n.language, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageChip(
            label: 'TR',
            isSelected: settings.language == 'tr',
            color: AppColors.neonCyan,
            onTap: () => settings.setLanguage('tr'),
          ),
          const SizedBox(width: 8),
          _LanguageChip(
            label: 'EN',
            isSelected: settings.language == 'en',
            color: AppColors.neonCyan,
            onTap: () => settings.setLanguage('en'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5), size: 14),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: Text(value, style: TextStyle(color: color, fontSize: 13)),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, AppLocalizations l10n) {
    return NeonContainer(
      borderColor: AppColors.neonPurple,
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.neonCyan, AppColors.neonMagenta],
                  ),
                  boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.4), blurRadius: 12)],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.developer,
                      style: const TextStyle(color: AppColors.textDim, fontSize: 11, letterSpacing: 1),
                    ),
                    NeonText(
                      text: AppConstants.developerName,
                      fontSize: 16,
                      color: AppColors.neonCyan,
                    ),
                    Text(
                      AppConstants.organization,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          const NeonDivider(color: AppColors.neonPurple),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              const Icon(Icons.email_outlined, color: AppColors.neonMagenta, size: 18),
              const SizedBox(width: 8),
              Text(
                AppConstants.developerEmail,
                style: const TextStyle(color: AppColors.neonMagenta, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.shareMessage}https://play.google.com/store'),
        backgroundColor: AppColors.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          side: const BorderSide(color: AppColors.neonGreen),
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : color.withOpacity(0.4),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
