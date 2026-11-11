import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../files/files_view.dart';
import '../settings/settings_view.dart';
import '../tools/tools_view.dart';
import 'home_controller.dart';
import 'views/home_tab.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      const HomeTab(),
      const ToolsView(),
      const FilesView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentTabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            height: 68,
            selectedIndex: controller.currentTabIndex.value,
            onDestinationSelected: controller.changeTab,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primary.withValues(alpha: 0.15),
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.layers_outlined),
                selectedIcon: Icon(Icons.layers_rounded, color: AppColors.primary),
                label: 'Tools',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder_rounded, color: AppColors.primary),
                label: 'Files',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primary),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
