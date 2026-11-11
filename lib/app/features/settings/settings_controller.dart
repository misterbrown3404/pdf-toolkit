import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/services/file_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import 'widgets/settings_about_dialog.dart';
import 'widgets/settings_theme_dialog.dart';

class SettingsController extends GetxController {
  final StorageService? storageService =
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;
  final FileService? fileService =
      Get.isRegistered<FileService>() ? Get.find<FileService>() : null;

  final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;
  final RxBool isPremium = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool defaultCompression = true.obs;
  final RxBool passwordReminder = false.obs;
  final RxBool defaultWatermark = false.obs;
  final RxString defaultPageFormat = 'A4'.obs;
  final RxString language = 'English (US)'.obs;

  final RxInt appStorageBytes = 0.obs;
  final RxInt cacheSizeBytes = 0.obs;
  final RxBool isClearingCache = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    calculateStorage();
  }

  void loadPreferences() {
    final storage = storageService;
    if (storage != null) {
      currentThemeMode.value = storage.getThemeMode();
      isPremium.value = storage.isPremium;
    }
  }

  Future<void> calculateStorage() async {
    try {
      final service = fileService;
      if (service != null) {
        final docs = await service.getSavedDocuments();
        appStorageBytes.value = docs.fold<int>(0, (sum, d) => sum + d.sizeInBytes);
      }

      // Calculate temporary cache directory size
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        int tempTotal = 0;
        final entities = tempDir.listSync(recursive: true);
        for (final entity in entities) {
          if (entity is File) {
            tempTotal += await entity.length();
          }
        }
        cacheSizeBytes.value = tempTotal;
      }
    } catch (_) {}
  }

  String get formattedAppStorage {
    final bytes = appStorageBytes.value;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get formattedCacheSize {
    final bytes = cacheSizeBytes.value;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get themeModeName {
    switch (currentThemeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    currentThemeMode.value = mode;
    Get.changeThemeMode(mode);
    final storage = storageService;
    if (storage != null) {
      await storage.saveThemeMode(mode);
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void toggleDefaultCompression(bool value) {
    defaultCompression.value = value;
  }

  void togglePasswordReminder(bool value) {
    passwordReminder.value = value;
  }

  void toggleDefaultWatermark(bool value) {
    defaultWatermark.value = value;
  }

  void setPageFormat(String format) {
    defaultPageFormat.value = format;
  }

  Future<void> clearCache() async {
    isClearingCache.value = true;
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        final entities = tempDir.listSync();
        for (final entity in entities) {
          try {
            await entity.delete(recursive: true);
          } catch (_) {}
        }
      }
      cacheSizeBytes.value = 0;
      Get.snackbar(
        'Cache Cleared',
        'Temporary PDF cache was emptied successfully.',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isClearingCache.value = false;
    }
  }

  void showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsThemeDialog(),
    );
  }

  void showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache?'),
        content: Text(
          'This will remove temporary cache files ($formattedCacheSize). Your saved PDFs will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              clearCache();
            },
            child: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const SettingsAboutDialog(),
    );
  }

  void showLegalDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void upgradeToPro() {
    Get.toNamed(AppRoutes.premium);
  }
}

