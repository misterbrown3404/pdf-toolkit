import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/components/tool_card.dart';
import '../../shared/models/tool_item_model.dart';
import '../../shared/utils/tools_catalog.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../home/home_controller.dart';

class ToolsView extends GetView<HomeController> {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Tools',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Everything you need to manage your documents',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildCategorySection(
            context,
            title: 'Organize & Manage',
            tools: ToolsCatalog.allTools
                .where((t) => t.category == ToolCategory.organize && t.id != 'more_tools')
                .toList(),
            isDark: isDark,
          ),
          _buildCategorySection(
            context,
            title: 'Convert & Create',
            tools: ToolsCatalog.allTools
                .where((t) => t.category == ToolCategory.convert)
                .toList(),
            isDark: isDark,
          ),
          _buildCategorySection(
            context,
            title: 'Scan & Digitize',
            tools: ToolsCatalog.allTools
                .where((t) => t.category == ToolCategory.scan)
                .toList(),
            isDark: isDark,
          ),
          _buildCategorySection(
            context,
            title: 'Optimize',
            tools: ToolsCatalog.allTools
                .where((t) => t.category == ToolCategory.optimize)
                .toList(),
            isDark: isDark,
          ),
          _buildCategorySection(
            context,
            title: 'Security & Privacy',
            tools: ToolsCatalog.allTools
                .where((t) => t.category == ToolCategory.security)
                .toList(),
            isDark: isDark,
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required List<ToolItemModel> tools,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 0.3,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return ToolCard(
              tool: tool,
              onTap: () => controller.onToolTap(tool.route),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
