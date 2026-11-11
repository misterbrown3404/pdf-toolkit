import 'package:flutter/material.dart';

class WatermarkConfigModel {
  final String watermarkType;
  final String text;
  final double opacity;
  final double rotationAngle;
  final double fontSize;
  final Color color;
  final String position;
  final String? imageLogoPath;

  const WatermarkConfigModel({
    this.watermarkType = 'text',
    this.text = 'CONFIDENTIAL',
    this.opacity = 0.25,
    this.rotationAngle = -45.0,
    this.fontSize = 38.0,
    this.color = const Color(0xFF64748B),
    this.position = 'center',
    this.imageLogoPath,
  });

  WatermarkConfigModel copyWith({
    String? watermarkType,
    String? text,
    double? opacity,
    double? rotationAngle,
    double? fontSize,
    Color? color,
    String? position,
    String? imageLogoPath,
  }) {
    return WatermarkConfigModel(
      watermarkType: watermarkType ?? this.watermarkType,
      text: text ?? this.text,
      opacity: opacity ?? this.opacity,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      position: position ?? this.position,
      imageLogoPath: imageLogoPath ?? this.imageLogoPath,
    );
  }
}
