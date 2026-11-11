import 'package:flutter/material.dart';

class PasswordStrengthModel {
  final int score;
  final String label;
  final Color color;

  const PasswordStrengthModel({
    required this.score,
    required this.label,
    required this.color,
  });
}
