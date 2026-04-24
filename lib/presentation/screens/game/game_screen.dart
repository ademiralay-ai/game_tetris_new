import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/neon_widgets.dart';
import '../../widgets/game/tetris_board_widget.dart';
import '../../providers/game_provider.dart';
import '../../providers/app_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/game_models.dart';
import '../../../services/game_engine.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final int levelIndex;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.levelIndex,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameProvider _gameProvider;
  late FocusNode _focusNode;
  double _dragStartX = 0;
  double _dragStartY = 0;
  bool _draggedX = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _gameProvider = GameProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameProvider.startGame(
        difficulty: widget.difficulty,
        levelIndex: widget.levelIndex,
      );
      _focusNode.requestFocus();
    });
    _gameProvider.addListener(_onGameStateChange);
  }

  void _onGameStateChange() {
    if (_gameProvider.gameState == GameState.gameOver) {
      _handleGameOver();
    }
  }

  void _handleGameOver() async {
    final livesProvider = context.read<LivesProvider>();
    final levelProvider = context.read<LevelProvider>();
    final score = _gameProvider.score;
    final linesCleared = _gameProvider.linesCleared;

    await livesProvider.decrementLife();
    await levelProvider.saveLevelResult(
      difficulty: widget.difficulty,
      levelIndex: widget.levelIndex,
      score: score,
      linesCleared: linesCleared,
    );

    if (mounted) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    final l10n = AppLocalizations.of(context);
    final livesProvider = context.read<LivesProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: const BorderSide(color: AppColors.neonRed, width: 2),
        ),
        title: NeonText(text: l10n.gameOver, color: AppColors.neonRed, fontSize: 24)
            .animate().shakeX(duration: 600.ms),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatColumn(label: l10n.score, value: _gameProvider.score.toString(), color: AppColors.neonCyan),
                _StatColumn(label: l10n.lines, value: _gameProvider.linesCleared.toString(), color: AppColors.neonGreen),
                _StatColumn(label: l10n.level, value: _gameProvider.level.toString(), color: AppColors.neonYellow),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            StarRatingWidget(
              stars: _gameProvider.engine.calculateStars(_gameProvider.linesCleared),
              size: 32,
            ).animate().scale(delay: 300.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSizes.lg),
            if (!livesProvider.hasLives)
              NeonButton(
                text: l10n.watchAd,
                color: AppColors.neonGreen,
                icon: Icons.play_circle_outline,
                onTap: () {
                  livesProvider.refillLives();
                  Navigator.pop(ctx);
                  _restartGame();
                },
              )
            else
              NeonButton(
                text: l10n.restart,
                color: AppColors.neonGreen,
                icon: Icons.refresh,
                onTap: () {
                  Navigator.pop(ctx);
                  _restartGame();
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(l10n.quit, style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    _gameProvider.startGame(
      difficulty: widget.difficulty,
      levelIndex: widget.levelIndex,
    );
  }

  @override
  void dispose() {
    _gameProvider.removeListener(_onGameStateChange);
    _gameProvider.stopGame();
    _gameProvider.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (_gameProvider.gameState != GameState.playing) return;
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          _gameProvider.moveLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          _gameProvider.moveRight();
          break;
        case LogicalKeyboardKey.arrowDown:
          _gameProvider.softDrop();
          break;
        case LogicalKeyboardKey.arrowUp:
        case LogicalKeyboardKey.keyX:
          _gameProvider.rotate();
          break;
        case LogicalKeyboardKey.space:
          _gameProvider.hardDrop();
          break;
        case LogicalKeyboardKey.keyZ:
          _gameProvider.rotateCounterClockwise();
          break;
        case LogicalKeyboardKey.keyC:
          _gameProvider.holdPiece();
          break;
        case LogicalKeyboardKey.escape:
        case LogicalKeyboardKey.keyP:
          if (_gameProvider.gameState == GameState.playing) {
            _gameProvider.pauseGame();
          } else if (_gameProvider.gameState == GameState.paused) {
            _gameProvider.resumeGame();
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameProvider,
      child: Consumer<GameProvider>(
        builder: (context, provider, _) {
          return KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _handleKeyEvent,
            child: Scaffold(
              backgroundColor: AppColors.darkBg,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return isWide
                        ? _buildWideLayout(context, provider)
                        : _buildNarrowLayout(context, provider);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, GameProvider provider) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: _buildLeftPanel(context, provider, l10n)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          child: _buildBoard(provider),
        ),
        Expanded(child: _buildRightPanel(context, provider, l10n)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, GameProvider provider) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _buildTopBar(context, provider, l10n),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildBoard(provider),
              ),
              _buildSideInfo(context, provider, l10n),
            ],
          ),
        ),
        _buildTouchControls(context, provider),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, GameProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              _buildScoreChip(l10n.score, provider.score.toString(), AppColors.neonCyan),
              const SizedBox(width: AppSizes.sm),
              _buildScoreChip(l10n.lines, provider.linesCleared.toString(), AppColors.neonGreen),
            ],
          ),
          IconButton(
            icon: Icon(
              provider.gameState == GameState.paused ? Icons.play_arrow : Icons.pause,
              color: AppColors.neonCyan,
            ),
            onPressed: () => provider.gameState == GameState.paused
                ? provider.resumeGame()
                : provider.pauseGame(),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: AppColors.textDim, fontSize: 9, letterSpacing: 1)),
        Text(value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: color.withOpacity(0.6), blurRadius: 6)],
          ),
        ),
      ],
    );
  }

  Widget _buildBoard(GameProvider provider) {
    return GestureDetector(
      onPanStart: (d) {
        _dragStartX = d.localPosition.dx;
        _dragStartY = d.localPosition.dy;
        _draggedX = false;
      },
      onPanUpdate: (d) {
        const threshold = 20.0;
        final dx = d.localPosition.dx - _dragStartX;
        final dy = d.localPosition.dy - _dragStartY;
        if (dx.abs() > threshold && !_draggedX) {
          _draggedX = true;
          if (dx > 0) { provider.moveRight(); } else { provider.moveLeft(); }
          _dragStartX = d.localPosition.dx;
        }
        if (dy > threshold * 1.5) {
          provider.softDrop();
          _dragStartY = d.localPosition.dy;
        }
      },
      onDoubleTap: () => provider.rotate(),
      onTap: () => provider.rotate(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.xs),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.neonCyan.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: AppColors.neonCyan.withOpacity(0.15), blurRadius: 20, spreadRadius: 2),
                ],
              ),
              child: TetrisBoard(
                board: provider.board,
                currentPiece: provider.currentPiece,
                ghostPiece: provider.ghostPiece,
              ),
            ),
          ),
          if (provider.gameState == GameState.paused)
            _buildPauseOverlay(),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: NeonText(text: 'PAUSED', fontSize: 32, color: AppColors.neonCyan),
      ),
    );
  }

  Widget _buildSideInfo(BuildContext context, GameProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TetrominoPreview(piece: provider.nextPiece, label: l10n.next),
          TetrominoPreview(piece: provider.heldPiece, label: l10n.hold),
          if (provider.combo > 1)
            NeonText(
              text: 'x${provider.combo}',
              fontSize: 20,
              color: AppColors.neonMagenta,
            ).animate().scale(curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(BuildContext context, GameProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildScoreCard(l10n.score, provider.score.toString(), AppColors.neonCyan),
          const SizedBox(height: AppSizes.md),
          _buildScoreCard(l10n.lines, provider.linesCleared.toString(), AppColors.neonGreen),
          const SizedBox(height: AppSizes.md),
          _buildScoreCard(l10n.level, provider.level.toString(), AppColors.neonYellow),
          const SizedBox(height: AppSizes.xl),
          NeonButton(
            text: provider.gameState == GameState.paused ? l10n.resume : l10n.pause,
            color: AppColors.neonCyan,
            onTap: () => provider.gameState == GameState.paused
                ? provider.resumeGame()
                : provider.pauseGame(),
          ),
          const SizedBox(height: AppSizes.md),
          NeonButton(
            text: l10n.quit,
            color: AppColors.neonRed,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, GameProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TetrominoPreview(piece: provider.nextPiece, label: l10n.next, cellSize: 24),
          const SizedBox(height: AppSizes.xl),
          TetrominoPreview(piece: provider.heldPiece, label: l10n.hold, cellSize: 24),
          if (provider.combo > 1) ...[
            const SizedBox(height: AppSizes.xl),
            NeonText(text: '${l10n.combo} x${provider.combo}', color: AppColors.neonMagenta, fontSize: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, String value, Color color) {
    return NeonContainer(
      borderColor: color,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 1)),
          NeonText(text: value, color: color, fontSize: 24),
        ],
      ),
    );
  }

  Widget _buildTouchControls(BuildContext context, GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(icon: Icons.arrow_back_ios, onTap: provider.moveLeft, color: AppColors.neonCyan),
          _ControlButton(icon: Icons.rotate_right, onTap: provider.rotate, color: AppColors.neonMagenta),
          _ControlButton(icon: Icons.arrow_downward, onTap: provider.softDrop, color: AppColors.neonGreen),
          _ControlButton(icon: Icons.vertical_align_bottom, onTap: provider.hardDrop, color: AppColors.neonYellow),
          _ControlButton(icon: Icons.arrow_forward_ios, onTap: provider.moveRight, color: AppColors.neonCyan),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
          color: color.withOpacity(0.1),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)],
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatColumn({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        NeonText(text: value, color: color, fontSize: 20),
      ],
    );
  }
}
