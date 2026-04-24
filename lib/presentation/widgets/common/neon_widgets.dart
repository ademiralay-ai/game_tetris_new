import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;
  final double? width;
  final double fontSize;
  final IconData? icon;

  const NeonButton({
    super.key,
    required this.text,
    this.onTap,
    this.color = AppColors.neonCyan,
    this.width,
    this.fontSize = 16,
    this.icon,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          border: Border.all(color: widget.color, width: _pressed ? 1 : 2),
          color: _pressed ? widget.color.withOpacity(0.25) : widget.color.withOpacity(0.1),
          boxShadow: _pressed
              ? null
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: widget.width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.color, size: widget.fontSize + 4),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: TextStyle(
                color: widget.color,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: widget.color.withOpacity(0.8),
                    blurRadius: 8,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double? blurRadius;
  final TextAlign? textAlign;
  final int? maxLines;

  const NeonText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.color = AppColors.neonCyan,
    this.fontWeight = FontWeight.bold,
    this.blurRadius,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: 1.5,
        shadows: [
          Shadow(
            color: color.withOpacity(0.9),
            blurRadius: blurRadius ?? 12,
          ),
          Shadow(
            color: color.withOpacity(0.4),
            blurRadius: (blurRadius ?? 12) * 2,
          ),
        ],
      ),
    );
  }
}

class NeonContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double borderRadius;
  final double borderWidth;

  const NeonContainer({
    super.key,
    required this.child,
    this.borderColor = AppColors.neonCyan,
    this.backgroundColor,
    this.padding,
    this.borderRadius = AppSizes.cardRadius,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.darkCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class HeartsWidget extends StatelessWidget {
  final int lives;
  final int maxLives;

  const HeartsWidget({
    super.key,
    required this.lives,
    this.maxLives = AppConstants.maxLives,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (i) {
        final isFilled = i < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Icon(
            isFilled ? Icons.favorite : Icons.favorite_border,
            color: isFilled ? AppColors.heartRed : AppColors.heartEmpty,
            size: 24,
            shadows: isFilled
                ? [Shadow(color: AppColors.heartRed.withOpacity(0.8), blurRadius: 8)]
                : null,
          ).animate(target: isFilled ? 1 : 0).scaleXY(
            begin: 1.0,
            end: 1.2,
            duration: 600.ms,
            curve: Curves.easeInOut,
          ),
        );
      }),
    );
  }
}

class StarRatingWidget extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarRatingWidget({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        final isFilled = i < stars;
        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          color: isFilled ? AppColors.starGold : AppColors.textDim,
          size: size,
          shadows: isFilled
              ? [Shadow(color: AppColors.starGold.withOpacity(0.8), blurRadius: 6)]
              : null,
        );
      }),
    );
  }
}

class NeonDivider extends StatelessWidget {
  final Color color;
  final double thickness;

  const NeonDivider({
    super.key,
    this.color = AppColors.neonCyan,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, color, color, Colors.transparent],
        ),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 4),
        ],
      ),
    );
  }
}
