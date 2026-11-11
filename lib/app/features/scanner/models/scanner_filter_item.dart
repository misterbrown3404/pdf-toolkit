import 'package:flutter/material.dart';

class ScannerFilterItem {
  final String id;
  final String label;
  final IconData icon;
  final Color accentColor;

  const ScannerFilterItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.accentColor,
  });
}

