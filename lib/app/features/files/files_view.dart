import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'files_controller.dart';
import 'widgets/files_category_chips.dart';
import 'widgets/files_document_grid_card.dart';
import 'widgets/files_document_tile.dart';
import 'widgets/files_empty_view.dart';
import 'widgets/files_header_app_bar.dart';
import 'widgets/files_search_bar.dart';
import 'widgets/files_storage_card.dart';

class FilesView extends GetView<FilesController> {
  const FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const FilesHeaderAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.loadFiles,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Search Bar (if visible)
            Obx(() {
              if (controller.isSearchVisible.value) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: FilesSearchBar(),
                );
              }
              return const SizedBox.shrink();
            }),

            // Device Storage Card
            const FilesStorageCard(),
            const SizedBox(height: 14),

            // Category Quick Filter Chips
            const FilesCategoryChips(),
            const SizedBox(height: 16),

            // Files Content
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final files = controller.filteredFiles;
              if (files.isEmpty) {
                return const FilesEmptyView();
              }

              // Grid view mode
              if (controller.isGridView.value) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: files.length,
                  itemBuilder: (ctx, index) {
                    return FilesDocumentGridCard(document: files[index]);
                  },
                );
              }

              // Grouped list view mode
              final groups = controller.groupedFiles;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groups.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              '${entry.value.length} files',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...entry.value.map((doc) => FilesDocumentTile(document: doc)),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
