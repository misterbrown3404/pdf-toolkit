import 'package:flutter/material.dart';
import '../models/scanner_filter_item.dart';

class ScannerFilterMatrix {
  ScannerFilterMatrix._();

  static const List<double> matrixOriginal = [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> matrixMagic = [
    1.25, 0, 0, 0, -12,
    0, 1.25, 0, 0, -12,
    0, 0, 1.25, 0, -12,
    0, 0, 0, 1, 0,
  ];

  static const List<double> matrixBw = [
    1.6, 1.6, 1.6, 0, -170,
    1.6, 1.6, 1.6, 0, -170,
    1.6, 1.6, 1.6, 0, -170,
    0, 0, 0, 1, 0,
  ];

  static const List<double> matrixGrayscale = [
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> matrixEco = [
    1.10, 0, 0, 0, 12,
    0, 1.05, 0, 0, 10,
    0, 0, 0.92, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<ScannerFilterItem> filters = [
    ScannerFilterItem(
      id: 'magic',
      label: 'Magic Color',
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFFF97316),
    ),
    ScannerFilterItem(
      id: 'original',
      label: 'Original',
      icon: Icons.photo_camera_back_rounded,
      accentColor: Color(0xFF3B82F6),
    ),
    ScannerFilterItem(
      id: 'bw',
      label: 'B&W Text',
      icon: Icons.contrast_rounded,
      accentColor: Color(0xFF0F172A),
    ),
    ScannerFilterItem(
      id: 'grayscale',
      label: 'Grayscale',
      icon: Icons.tonality_rounded,
      accentColor: Color(0xFF64748B),
    ),
    ScannerFilterItem(
      id: 'eco',
      label: 'Warm / Eco',
      icon: Icons.menu_book_rounded,
      accentColor: Color(0xFFD97706),
    ),
  ];

  static ColorFilter getFilter(String filterId) {
    switch (filterId) {
      case 'magic':
        return const ColorFilter.matrix(matrixMagic);
      case 'bw':
        return const ColorFilter.matrix(matrixBw);
      case 'grayscale':
        return const ColorFilter.matrix(matrixGrayscale);
      case 'eco':
        return const ColorFilter.matrix(matrixEco);
      case 'original':
      default:
        return const ColorFilter.matrix(matrixOriginal);
    }
  }
}

