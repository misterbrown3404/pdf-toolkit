class PdfDocumentModel {
  final String id;
  final String name;
  final String path;
  final int sizeInBytes;
  final DateTime modifiedAt;
  final int? pageCount;
  final bool isEncrypted;

  PdfDocumentModel({
    required this.id,
    required this.name,
    required this.path,
    required this.sizeInBytes,
    required this.modifiedAt,
    this.pageCount,
    this.isEncrypted = false,
  });

  PdfDocumentModel copyWith({
    String? id,
    String? name,
    String? path,
    int? sizeInBytes,
    DateTime? modifiedAt,
    int? pageCount,
    bool? isEncrypted,
  }) {
    return PdfDocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      pageCount: pageCount ?? this.pageCount,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'sizeInBytes': sizeInBytes,
      'modifiedAt': modifiedAt.toIso8601String(),
      'pageCount': pageCount,
      'isEncrypted': isEncrypted,
    };
  }

  factory PdfDocumentModel.fromMap(Map<String, dynamic> map) {
    return PdfDocumentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      sizeInBytes: map['sizeInBytes'] ?? 0,
      modifiedAt: DateTime.tryParse(map['modifiedAt'] ?? '') ?? DateTime.now(),
      pageCount: map['pageCount'],
      isEncrypted: map['isEncrypted'] ?? false,
    );
  }
}

