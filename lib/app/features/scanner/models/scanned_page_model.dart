import 'dart:io';

class ScannedPageModel {
  final String id;
  final File file;
  final String filter;
  final int rotationQuarterTurns;
  final DateTime capturedAt;

  const ScannedPageModel({
    required this.id,
    required this.file,
    this.filter = 'magic',
    this.rotationQuarterTurns = 0,
    required this.capturedAt,
  });

  ScannedPageModel copyWith({
    String? id,
    File? file,
    String? filter,
    int? rotationQuarterTurns,
    DateTime? capturedAt,
  }) {
    return ScannedPageModel(
      id: id ?? this.id,
      file: file ?? this.file,
      filter: filter ?? this.filter,
      rotationQuarterTurns: rotationQuarterTurns ?? this.rotationQuarterTurns,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }
}

