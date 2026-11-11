import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/file_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';
import '../../theme/app_colors.dart';
import 'models/file_category_enum.dart';
import 'models/file_sort_enum.dart';
import 'widgets/files_details_bottom_sheet.dart';
import 'widgets/files_sort_bottom_sheet.dart';

class FilesController extends GetxController {
  FileService? get fileService =>
      Get.isRegistered<FileService>() ? Get.find<FileService>() : null;
  StorageService? get storageService =>
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

  final RxList<PdfDocumentModel> allFiles = <PdfDocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearchVisible = false.obs;
  final Rx<FileCategory> selectedCategory = FileCategory.all.obs;
  final Rx<FileSort> currentSort = FileSort.dateDesc.obs;
  final RxBool isGridView = false.obs;

  late final TextEditingController searchInputController;

  @override
  void onInit() {
    super.onInit();
    searchInputController = TextEditingController();
    loadFiles();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }

  Future<void> loadFiles() async {
    isLoading.value = true;
    try {
      final service = fileService;
      final saved = service != null ? await service.getSavedDocuments() : <PdfDocumentModel>[];

      final storage = storageService;
      final recentsRaw = storage != null ? storage.getRecentFiles() : <Map<String, dynamic>>[];
      final recents = recentsRaw.map((e) => PdfDocumentModel.fromMap(e)).toList();

      final fileMap = <String, PdfDocumentModel>{};
      for (final doc in saved) {
        fileMap[doc.path] = doc;
      }
      for (final doc in recents) {
        if (!fileMap.containsKey(doc.path)) {
          // verify file still exists
          if (File(doc.path).existsSync()) {
            fileMap[doc.path] = doc;
          }
        }
      }

      if (fileMap.isNotEmpty) {
        allFiles.assignAll(fileMap.values.toList());
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<PdfDocumentModel> get filteredFiles {
    var list = allFiles.toList();

    // Category filter
    switch (selectedCategory.value) {
      case FileCategory.all:
        break;
      case FileCategory.pdf:
        list = list.where((f) => f.path.toLowerCase().endsWith('.pdf')).toList();
        break;
      case FileCategory.scanned:
        list = list
            .where((f) =>
                f.name.toLowerCase().contains('scan') ||
                f.name.toLowerCase().contains('receipt') ||
                f.name.toLowerCase().contains('doc_'))
            .toList();
        break;
      case FileCategory.compressed:
        list = list
            .where((f) =>
                f.name.toLowerCase().contains('compress') ||
                f.name.toLowerCase().contains('small'))
            .toList();
        break;
      case FileCategory.protected:
        list = list
            .where((f) =>
                f.isEncrypted ||
                f.name.toLowerCase().contains('protect') ||
                f.name.toLowerCase().contains('locked'))
            .toList();
        break;
    }

    // Search query filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((f) => f.name.toLowerCase().contains(query)).toList();
    }

    // Sort
    switch (currentSort.value) {
      case FileSort.dateDesc:
        list.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
        break;
      case FileSort.dateAsc:
        list.sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
        break;
      case FileSort.nameAsc:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case FileSort.nameDesc:
        list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case FileSort.sizeDesc:
        list.sort((a, b) => b.sizeInBytes.compareTo(a.sizeInBytes));
        break;
      case FileSort.sizeAsc:
        list.sort((a, b) => a.sizeInBytes.compareTo(b.sizeInBytes));
        break;
    }

    return list;
  }

  Map<String, List<PdfDocumentModel>> get groupedFiles {
    final grouped = <String, List<PdfDocumentModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final doc in filteredFiles) {
      final docDate = DateTime(
        doc.modifiedAt.year,
        doc.modifiedAt.month,
        doc.modifiedAt.day,
      );
      String key;
      if (docDate == today) {
        key = 'Today';
      } else if (docDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = 'Earlier';
      }
      grouped.putIfAbsent(key, () => []).add(doc);
    }

    return grouped;
  }

  int countForCategory(FileCategory category) {
    switch (category) {
      case FileCategory.all:
        return allFiles.length;
      case FileCategory.pdf:
        return allFiles.where((f) => f.path.toLowerCase().endsWith('.pdf')).length;
      case FileCategory.scanned:
        return allFiles
            .where((f) =>
                f.name.toLowerCase().contains('scan') ||
                f.name.toLowerCase().contains('receipt') ||
                f.name.toLowerCase().contains('doc_'))
            .length;
      case FileCategory.compressed:
        return allFiles
            .where((f) =>
                f.name.toLowerCase().contains('compress') ||
                f.name.toLowerCase().contains('small'))
            .length;
      case FileCategory.protected:
        return allFiles
            .where((f) =>
                f.isEncrypted ||
                f.name.toLowerCase().contains('protect') ||
                f.name.toLowerCase().contains('locked'))
            .length;
    }
  }

  int get totalSizeInBytes {
    return allFiles.fold<int>(0, (sum, file) => sum + file.sizeInBytes);
  }

  String get formattedTotalStorage {
    if (totalSizeInBytes < 1024 * 1024) {
      return '${(totalSizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void toggleSearch() {
    isSearchVisible.toggle();
    if (!isSearchVisible.value) {
      searchQuery.value = '';
      searchInputController.clear();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setCategory(FileCategory category) {
    selectedCategory.value = category;
  }

  void setSort(FileSort sort) {
    currentSort.value = sort;
  }

  void toggleViewMode() {
    isGridView.toggle();
  }

  void openDocument(PdfDocumentModel doc) {
    Get.toNamed(
      AppRoutes.pdfViewer,
      arguments: {'path': doc.path, 'title': doc.name},
    );
  }

  Future<void> shareDocument(PdfDocumentModel doc) async {
    final service = fileService;
    if (service != null) {
      await service.shareFile(doc.path, subject: doc.name);
    }
  }

  Future<void> duplicateDocument(PdfDocumentModel doc) async {
    final service = fileService;
    if (service != null) {
      final duplicated = await service.duplicateFile(doc.path);
      if (duplicated != null) {
        await loadFiles();
        Get.snackbar(
          'Duplicated',
          'Created copy "${duplicated.name}"',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  Future<void> renameDocument(PdfDocumentModel doc, String newName) async {
    if (newName.trim().isEmpty || newName.trim() == doc.name) return;
    final service = fileService;
    if (service != null) {
      final renamed = await service.renameFile(doc.path, newName.trim());
      if (renamed != null) {
        await loadFiles();
        Get.snackbar(
          'Renamed',
          'Document renamed to "${renamed.name}"',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  Future<void> deleteDocument(PdfDocumentModel doc) async {
    final service = fileService;
    if (service != null) {
      final deleted = await service.deleteFile(doc.path);
      if (deleted) {
        await loadFiles();
        Get.snackbar(
          'Deleted',
          'Document removed successfully',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  void openProtect(PdfDocumentModel doc) {
    Get.toNamed(AppRoutes.protectPdf, arguments: {'path': doc.path});
  }

  void openWatermark(PdfDocumentModel doc) {
    Get.toNamed(AppRoutes.watermark, arguments: {'path': doc.path});
  }

  void openCompress(PdfDocumentModel doc) {
    Get.toNamed(AppRoutes.compressPdf, arguments: {'path': doc.path});
  }

  void openSplit(PdfDocumentModel doc) {
    Get.toNamed(AppRoutes.splitPdf, arguments: {'path': doc.path});
  }

  void showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilesSortBottomSheet(),
    );
  }

  void showFileDetails(BuildContext context, PdfDocumentModel doc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FilesDetailsBottomSheet(document: doc),
    );
  }

  Future<void> showRenameDialog(BuildContext context, PdfDocumentModel doc) async {
    final textController = TextEditingController(text: doc.name);
    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Rename File'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'File Name',
              hintText: 'Enter new name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = textController.text.trim();
                Navigator.of(dialogCtx).pop();
                if (newName.isNotEmpty) {
                  renameDocument(doc, newName);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(BuildContext context, PdfDocumentModel doc) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete File?'),
          content: Text(
            'Are you sure you want to permanently delete "${doc.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                deleteDocument(doc);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
