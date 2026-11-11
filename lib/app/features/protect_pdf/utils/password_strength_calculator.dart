import 'package:flutter/material.dart';
import '../models/password_strength_model.dart';

class PasswordStrengthCalculator {
  static PasswordStrengthModel calculate(String password) {
    if (password.isEmpty) {
      return const PasswordStrengthModel(
        score: 0,
        label: '',
        color: Colors.transparent,
      );
    }

    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigits = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    if (hasLetters && hasDigits) score++;
    if (hasSpecial && password.length >= 8) score++;

    if (score <= 1) {
      return const PasswordStrengthModel(
        score: 1,
        label: 'Weak strength',
        color: Color(0xFFEF4444),
      );
    } else if (score == 2 || score == 3) {
      return const PasswordStrengthModel(
        score: 2,
        label: 'Medium strength',
        color: Color(0xFFF59E0B),
      );
    } else {
      return const PasswordStrengthModel(
        score: 3,
        label: 'Strong password',
        color: Color(0xFF10B981),
      );
    }
  }
}
