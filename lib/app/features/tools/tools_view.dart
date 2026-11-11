import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'models/tools_filter_category_enum.dart';
import 'tools_controller.dart';
import 'widgets/tools_category_filter_pills.dart';
import 'widgets/tools_empty_state.dart';
import 'widgets/tools_grid_card.dart';
import 'widgets/tools_header_banner.dart';
import 'widgets/tools_popular_section.dart';
import 'widgets/tools_search_bar.dart';

class ToolsView extends GetView<ToolsController> {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Header Banner
            const ToolsHeaderBanner(),

            // Search Bar
            const ToolsSearchBar(),
            const SizedBox(height: 14),

            // Category Filter Pills
            const ToolsCategoryFilterPills(),
            const SizedBox(height: 18),

            // Popular Tools Section (shown when no search and "All" category)
            Obx(() {
              if (controller.searchQuery.value.isEmpty &&
                  controller.selectedCategory.value == ToolsFilterCategory.all) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ToolsPopularSection(),
                );
              }
              return const SizedBox.shrink();
            }),

            // Section Title
            Obx(() {
              final isSearching = controller.searchQuery.value.isNotEmpty;
              final count = controller.filteredTools.length;
              final title = isSearching ? 'Search Results ($count)' : 'All Tools';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (!isSearching)
                      Text(
                        '$count tools available',
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                        ),
                      ),
                  ],
                ),
              );
            }),

            // Tools List or Empty State
            Obx(() {
              final tools = controller.filteredTools;
              if (tools.isEmpty) {
                return const ToolsEmptyState();
              }

              return Column(
                children: tools.map((tool) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ToolsGridCard(tool: tool),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
