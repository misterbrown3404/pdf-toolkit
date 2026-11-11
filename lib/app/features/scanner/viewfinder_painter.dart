import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ViewfinderPainter extends CustomPainter {
  final Color cornerColor;
  final double cornerLength;
  final double strokeWidth;

  const ViewfinderPainter({
    this.cornerColor = AppColors.primary,
    this.cornerLength = 38.0,
    this.strokeWidth = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 20.0;
    final left = padding;
    final top = padding;
    final right = size.width - padding;
    final bottom = size.height - padding;

    // Faint boundary frame
    final framePaint = Paint()
      ..color = cornerColor.withValues(alpha: 0.22)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromLTRBR(left, top, right, bottom, const Radius.circular(16));
    canvas.drawRRect(rrect, framePaint);

    // Glowing corner paint
    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Dot paint for anchor handles
    final dotFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const dotRadius = 5.0;

    // Top-Left Corner
    canvas.drawLine(Offset(left, top + cornerLength), Offset(left, top + 12), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(left, top, 24, 24),
      3.14159,
      1.57079,
      false,
      cornerPaint,
    );
    canvas.drawLine(Offset(left + 12, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawCircle(Offset(left, top), dotRadius, dotFillPaint);
    canvas.drawCircle(Offset(left, top), dotRadius, dotBorderPaint);

    // Top-Right Corner
    canvas.drawLine(Offset(right - cornerLength, top), Offset(right - 12, top), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(right - 24, top, 24, 24),
      -1.57079,
      1.57079,
      false,
      cornerPaint,
    );
    canvas.drawLine(Offset(right, top + 12), Offset(right, top + cornerLength), cornerPaint);
    canvas.drawCircle(Offset(right, top), dotRadius, dotFillPaint);
    canvas.drawCircle(Offset(right, top), dotRadius, dotBorderPaint);

    // Bottom-Left Corner
    canvas.drawLine(Offset(left, bottom - cornerLength), Offset(left, bottom - 12), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(left, bottom - 24, 24, 24),
      1.57079,
      1.57079,
      false,
      cornerPaint,
    );
    canvas.drawLine(Offset(left + 12, bottom), Offset(left + cornerLength, bottom), cornerPaint);
    canvas.drawCircle(Offset(left, bottom), dotRadius, dotFillPaint);
    canvas.drawCircle(Offset(left, bottom), dotRadius, dotBorderPaint);

    // Bottom-Right Corner
    canvas.drawLine(Offset(right - cornerLength, bottom), Offset(right - 12, bottom), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(right - 24, bottom - 24, 24, 24),
      0,
      1.57079,
      false,
      cornerPaint,
    );
    canvas.drawLine(Offset(right, bottom - 12), Offset(right, bottom - cornerLength), cornerPaint);
    canvas.drawCircle(Offset(right, bottom), dotRadius, dotFillPaint);
    canvas.drawCircle(Offset(right, bottom), dotRadius, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
