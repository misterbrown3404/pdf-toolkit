import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../storage/storage_keys.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // Theme
  ThemeMode getThemeMode() {
    final mode = _box.read<String>(StorageKeys.themeMode);
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final modeStr = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    await _box.write(StorageKeys.themeMode, modeStr);
  }

  // Premium status
  bool get isPremium => _box.read<bool>(StorageKeys.isPremium) ?? false;

  Future<void> setPremium(bool value) async {
    await _box.write(StorageKeys.isPremium, value);
  }

  // Recent files
  List<Map<String, dynamic>> getRecentFiles() {
    final list = _box.read<List<dynamic>>(StorageKeys.recentFiles);
    if (list == null) return [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> addRecentFile(Map<String, dynamic> fileData) async {
    final recents = getRecentFiles();
    // Remove if already exists (by path)
    recents.removeWhere((item) => item['path'] == fileData['path']);
    recents.insert(0, fileData);
    // Keep top 20
    if (recents.length > 20) {
      recents.removeRange(20, recents.length);
    }
    await _box.write(StorageKeys.recentFiles, recents);
  }

  Future<void> removeRecentFile(String path) async {
    final recents = getRecentFiles();
    recents.removeWhere((item) => item['path'] == path);
    await _box.write(StorageKeys.recentFiles, recents);
  }

  Future<void> clearRecentFiles() async {
    await _box.remove(StorageKeys.recentFiles);
  }
}

