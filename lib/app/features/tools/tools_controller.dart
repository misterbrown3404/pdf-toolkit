import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/tool_category_enum.dart';
import '../../shared/models/tool_item_model.dart';
import '../../shared/utils/tools_catalog.dart';
import 'models/tools_filter_category_enum.dart';
import 'widgets/tools_pro_dialog.dart';

class ToolsController extends GetxController {
  final StorageService? storageService =
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

  final RxString searchQuery = ''.obs;
  final Rx<ToolsFilterCategory> selectedCategory = ToolsFilterCategory.all.obs;
  late final TextEditingController searchInputController;

  @override
  void onInit() {
    super.onInit();
    searchInputController = TextEditingController();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchInputController.clear();
  }

  void setCategory(ToolsFilterCategory category) {
    selectedCategory.value = category;
  }

  List<ToolItemModel> get popularTools {
    return ToolsCatalog.allTools.where((t) {
      return ['compress', 'merge', 'split', 'pdf_to_image'].contains(t.id);
    }).toList();
  }

  List<ToolItemModel> get filteredTools {
    var list = ToolsCatalog.allTools.where((t) => t.id != 'more_tools').toList();

    // Filter by category
    switch (selectedCategory.value) {
      case ToolsFilterCategory.all:
        break;
      case ToolsFilterCategory.organize:
        list = list.where((t) => t.category == ToolCategory.organize).toList();
        break;
      case ToolsFilterCategory.convert:
        list = list
            .where((t) => t.category == ToolCategory.convert || t.category == ToolCategory.scan)
            .toList();
        break;
      case ToolsFilterCategory.security:
        list = list.where((t) => t.category == ToolCategory.security).toList();
        break;
      case ToolsFilterCategory.optimize:
        list = list.where((t) => t.category == ToolCategory.optimize).toList();
        break;
    }

    // Filter by search query
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((t) {
        return t.title.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  int countForCategory(ToolsFilterCategory category) {
    final all = ToolsCatalog.allTools.where((t) => t.id != 'more_tools').toList();
    switch (category) {
      case ToolsFilterCategory.all:
        return all.length;
      case ToolsFilterCategory.organize:
        return all.where((t) => t.category == ToolCategory.organize).length;
      case ToolsFilterCategory.convert:
        return all
            .where((t) => t.category == ToolCategory.convert || t.category == ToolCategory.scan)
            .length;
      case ToolsFilterCategory.security:
        return all.where((t) => t.category == ToolCategory.security).length;
      case ToolsFilterCategory.optimize:
        return all.where((t) => t.category == ToolCategory.optimize).length;
    }
  }

  void onToolTap(BuildContext context, ToolItemModel tool) {
    final isUserPremium = storageService?.isPremium ?? false;

    if (tool.isPremium && !isUserPremium) {
      showDialog(
        context: context,
        builder: (_) => ToolsProDialog(tool: tool),
      );
      return;
    }

    if (tool.id == 'unlock') {
      Get.toNamed(AppRoutes.protectPdf, arguments: {'initialMode': 1});
      return;
    }

    if (tool.id == 'pdf_to_word' || tool.id == 'pdf_to_excel' || tool.id == 'pdf_to_powerpoint') {
      _showComingSoonDialog(context, tool);
      return;
    }

    Get.toNamed(tool.route);
  }

  void _showComingSoonDialog(BuildContext context, ToolItemModel tool) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(tool.icon, color: tool.color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${tool.title} Coming Soon',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          '${tool.title} conversion is currently being finalized for our upcoming release. Pro members will receive unlimited access automatically.',
          style: const TextStyle(height: 1.45),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
