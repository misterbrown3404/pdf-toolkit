import 'package:flutter/material.dart';

class SplashBottomWavePainter extends CustomPainter {
  const SplashBottomWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Layer 1: Back subtle wave crest
    final backPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFED7AA),
          Color(0xFFFDBA74),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final backPath = Path()
      ..moveTo(0, size.height * 0.28)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.12,
        size.width * 0.45,
        size.height * 0.38,
        size.width * 0.7,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.05,
        size.width * 0.95,
        size.height * 0.1,
        size.width,
        size.height * 0.08,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(backPath, backPaint);

    // Layer 2: Middle fluid swell wave
    final middlePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFB923C).withValues(alpha: 0.85),
          const Color(0xFFF97316).withValues(alpha: 0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final middlePath = Path()
      ..moveTo(0, size.height * 0.42)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.22,
        size.width * 0.52,
        size.height * 0.46,
        size.width * 0.78,
        size.height * 0.22,
      )
      ..cubicTo(
        size.width * 0.9,
        size.height * 0.12,
        size.width * 0.96,
        size.height * 0.14,
        size.width,
        size.height * 0.12,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(middlePath, middlePaint);

    // Layer 3: Foreground main vibrant orange wave
    final frontPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFB923C),
          Color(0xFFF97316),
          Color(0xFFEA580C),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final frontPath = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.34,
        size.width * 0.5,
        size.height * 0.56,
        size.width * 0.82,
        size.height * 0.32,
      )
      ..cubicTo(
        size.width * 0.92,
        size.height * 0.24,
        size.width * 0.97,
        size.height * 0.26,
        size.width,
        size.height * 0.22,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

