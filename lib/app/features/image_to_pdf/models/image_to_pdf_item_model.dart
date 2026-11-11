import 'dart:io';

class ImageToPdfItemModel {
  final String id;
  final File file;
  final int rotationQuarterTurns;
  final int sizeInBytes;

  const ImageToPdfItemModel({
    required this.id,
    required this.file,
    this.rotationQuarterTurns = 0,
    required this.sizeInBytes,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  ImageToPdfItemModel copyWith({
    String? id,
    File? file,
    int? rotationQuarterTurns,
    int? sizeInBytes,
  }) {
    return ImageToPdfItemModel(
      id: id ?? this.id,
      file: file ?? this.file,
      rotationQuarterTurns: rotationQuarterTurns ?? this.rotationQuarterTurns,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
    );
  }
}

