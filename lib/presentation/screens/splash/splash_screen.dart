import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../home/home_screen.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Animated background grid
          _buildBackgroundGrid(),
          // Scanline effect
          _buildScanline(),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                _buildLogo(),
                const SizedBox(height: AppSizes.xl),
                // App name
                NeonText(
                  text: 'NEON',
                  fontSize: 56,
                  color: AppColors.neonCyan,
                  blurRadius: 20,
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: -0.3, end: 0),
                const SizedBox(height: 4),
                NeonText(
                  text: 'TETRIS',
                  fontSize: 56,
                  color: AppColors.neonMagenta,
                  blurRadius: 20,
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: AppSizes.xxl),
                // Loading dots
                _buildLoadingDots(),
                const SizedBox(height: AppSizes.lg),
                Text(
                  'by ${AppConstants.developerName}',
                  style: TextStyle(
                    color: AppColors.textDim,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 1500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return CustomPaint(
      painter: _GridBackgroundPainter(animation: _scanlineController),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildScanline() {
    return AnimatedBuilder(
      animation: _scanlineController,
      builder: (context, _) {
        final screenH = MediaQuery.of(context).size.height;
        return Positioned(
          top: screenH * _scanlineController.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.neonCyan.withOpacity(0.3),
                  AppColors.neonCyan.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + _pulseController.value * 0.05,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.neonCyan.withOpacity(0.8 + _pulseController.value * 0.2),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonCyan.withOpacity(0.3 + _pulseController.value * 0.2),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: 16,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, i) {
                final colors = [
                  AppColors.neonCyan, AppColors.neonMagenta, AppColors.neonGreen,
                  AppColors.neonYellow, AppColors.neonOrange, AppColors.neonPurple,
                ];
                final active = [0, 1, 2, 3, 4, 6, 7, 8, 9, 10];
                if (active.contains(i)) {
                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: colors[i % colors.length].withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, curve: Curves.elasticOut);
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.neonCyan,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.6), blurRadius: 6)],
            ),
          )
          .animate(onPlay: (ctrl) => ctrl.repeat())
          .fadeIn(duration: 400.ms, delay: (i * 200).ms)
          .then(delay: 600.ms)
          .fadeOut(duration: 400.ms),
        );
      }),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  _GridBackgroundPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridBackgroundPainter old) => false;
}
