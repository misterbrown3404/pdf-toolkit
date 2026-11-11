import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../home_controller.dart';
import '../widgets/home_header_app_bar.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_recent_files_card.dart';
import '../widgets/home_tools_section.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refreshAllFiles,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // 1. Top App Bar Header
          HomeHeaderAppBar(controller: controller),

          // 2. Hero Promotional Banner Card
          SliverToBoxAdapter(
            child: HomeHeroBanner(
              onExploreTap: () => controller.changeTab(1),
            ),
          ),

          // 3. Quick Access Tools Grid
          SliverToBoxAdapter(
            child: HomeToolsSection(controller: controller),
          ),

          // 4. Recent Documents Card
          SliverToBoxAdapter(
            child: HomeRecentFilesCard(controller: controller),
          ),
        ],
      ),
    );
  }
}
