import 'package:flutter/material.dart';

enum ToolCategory {
  organize,
  convert,
  security,
  optimize,
  scan,
}

class ToolItemModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
  final ToolCategory category;
  final bool isPremium;
  final bool isNew;

  const ToolItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
    required this.category,
    this.isPremium = false,
    this.isNew = false,
  });
}

