import 'package:flutter/material.dart';

class SplashTopWavePainter extends CustomPainter {
  const SplashTopWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Top-left organic warm gradient wave
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFEA580C), // Deep orange
          Color(0xFFF97316), // Brand orange
          Color(0xFFFB923C), // Tangerine bright
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.95,
        size.width * 0.55,
        size.height * 0.65,
        size.width * 0.75,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.15,
        size.width * 0.92,
        0,
        size.width,
        0,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Subtle inner highlight curve
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final highlightPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.45)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.55,
        size.width * 0.45,
        size.height * 0.3,
        size.width * 0.6,
        0,
      )
      ..close();

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

