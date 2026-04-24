import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/game_models.dart';

class TetrisBoard extends StatelessWidget {
  final List<List<Color?>> board;
  final Tetromino? currentPiece;
  final Tetromino? ghostPiece;

  const TetrisBoard({
    super.key,
    required this.board,
    this.currentPiece,
    this.ghostPiece,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppSizes.boardWidth / AppSizes.boardHeight,
      child: CustomPaint(
        painter: _BoardPainter(
          board: board,
          currentPiece: currentPiece,
          ghostPiece: ghostPiece,
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final List<List<Color?>> board;
  final Tetromino? currentPiece;
  final Tetromino? ghostPiece;

  _BoardPainter({required this.board, this.currentPiece, this.ghostPiece});

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / AppSizes.boardWidth;
    final cellH = size.height / AppSizes.boardHeight;

    // Draw background grid
    final gridPaint = Paint()
      ..color = AppColors.darkBg3
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = AppColors.textDim.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int r = 0; r < AppSizes.boardHeight; r++) {
      for (int c = 0; c < AppSizes.boardWidth; c++) {
        final rect = Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH);
        canvas.drawRect(rect, gridPaint);
        canvas.drawRect(rect, borderPaint);
      }
    }

    // Draw ghost piece
    if (ghostPiece != null) {
      for (final cell in ghostPiece!.cells) {
        if (cell.row >= 0 && cell.row < AppSizes.boardHeight) {
          _drawCell(
            canvas,
            cell.col * cellW,
            cell.row * cellH,
            cellW,
            cellH,
            AppColors.tetrominoGhost,
            isGhost: true,
          );
        }
      }
    }

    // Draw board cells
    for (int r = 0; r < AppSizes.boardHeight; r++) {
      for (int c = 0; c < AppSizes.boardWidth; c++) {
        final color = board[r][c];
        if (color != null) {
          _drawCell(canvas, c * cellW, r * cellH, cellW, cellH, color);
        }
      }
    }

    // Draw current piece
    if (currentPiece != null) {
      for (final cell in currentPiece!.cells) {
        if (cell.row >= 0 && cell.row < AppSizes.boardHeight) {
          _drawCell(
            canvas,
            cell.col * cellW,
            cell.row * cellH,
            cellW,
            cellH,
            currentPiece!.color,
          );
        }
      }
    }
  }

  void _drawCell(Canvas canvas, double x, double y, double w, double h, Color color, {bool isGhost = false}) {
    final gap = w * 0.06;
    final rect = Rect.fromLTWH(x + gap, y + gap, w - gap * 2, h - gap * 2);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

    if (isGhost) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rRect, paint);
      return;
    }

    // Fill
    final fillPaint = Paint()
      ..color = color.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rRect, fillPaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawRRect(rRect, glowPaint);

    // Highlight top-left
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final highlightRect = Rect.fromLTWH(x + gap, y + gap, w * 0.4, h * 0.2);
    final highlightRRect = RRect.fromRectAndRadius(highlightRect, const Radius.circular(2));
    canvas.drawRRect(highlightRRect, highlightPaint);

    // Border
    final borderPaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rRect, borderPaint);
  }

  @override
  bool shouldRepaint(_BoardPainter old) => true;
}

class TetrominoPreview extends StatelessWidget {
  final Tetromino? piece;
  final String label;
  final double cellSize;

  const TetrominoPreview({
    super.key,
    required this.piece,
    required this.label,
    this.cellSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: cellSize * 4,
          height: cellSize * 4,
          child: piece == null
              ? const SizedBox()
              : CustomPaint(
                  painter: _PreviewPainter(piece: piece!, cellSize: cellSize),
                ),
        ),
      ],
    );
  }
}

class _PreviewPainter extends CustomPainter {
  final Tetromino piece;
  final double cellSize;

  _PreviewPainter({required this.piece, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final shape = piece.currentShape;
    final rows = shape.length;
    final cols = shape[0].length;

    // Center the piece
    final totalW = cols * cellSize;
    final totalH = rows * cellSize;
    final offsetX = (size.width - totalW) / 2;
    final offsetY = (size.height - totalH) / 2;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (shape[r][c] == 1) {
          final x = offsetX + c * cellSize;
          final y = offsetY + r * cellSize;
          final gap = cellSize * 0.06;
          final rect = Rect.fromLTWH(x + gap, y + gap, cellSize - gap * 2, cellSize - gap * 2);
          final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

          final fillPaint = Paint()
            ..color = piece.color.withOpacity(0.85)
            ..style = PaintingStyle.fill;
          canvas.drawRRect(rRect, fillPaint);

          final glowPaint = Paint()
            ..color = piece.color.withOpacity(0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
          canvas.drawRRect(rRect, glowPaint);

          final borderPaint = Paint()
            ..color = piece.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;
          canvas.drawRRect(rRect, borderPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_PreviewPainter old) => old.piece != piece;
}
