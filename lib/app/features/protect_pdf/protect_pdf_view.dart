import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'models/protect_mode_enum.dart';
import 'protect_pdf_controller.dart';
import 'widgets/protect_bottom_bar.dart';
import 'widgets/protect_file_card.dart';
import 'widgets/protect_header_banner.dart';
import 'widgets/protect_mode_selector.dart';
import 'widgets/protect_password_card.dart';
import 'widgets/protect_permissions_card.dart';
import 'widgets/protect_success_view.dart';
import 'widgets/protect_warning_card.dart';

class ProtectPdfView extends GetView<ProtectPdfController> {
  const ProtectPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFFFBF5),
      body: SafeArea(
        child: Obx(() {
          if (controller.isSuccess.value) {
            return ProtectSuccessView(controller: controller);
          }

          final mode = controller.mode.value;
          final isProtect = mode == ProtectMode.protect;

          return Column(
            children: [
              // 1. Header Banner
              ProtectHeaderBanner(mode: mode),

              // 2. Protect vs Unlock Mode Segmented Selector
              ProtectModeSelector(
                currentMode: mode,
                onModeChanged: controller.setMode,
              ),

              // 3. Scrollable Form Elements
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      // Document Card
                      ProtectFileCard(
                        selectedPdf: controller.selectedPdf.value,
                        mode: mode,
                        onPickPdf: controller.pickPdf,
                        onClearPdf: controller.clearPdf,
                        recentFiles: controller.recentFiles,
                        onSelectRecent: controller.selectRecentPdf,
                      ),

                      // Password Card
                      ProtectPasswordCard(
                        mode: mode,
                        passwordController: controller.passwordController,
                        confirmPasswordController: controller.confirmPasswordController,
                        isPasswordObscured: controller.isPasswordObscured.value,
                        isConfirmPasswordObscured: controller.isConfirmPasswordObscured.value,
                        onTogglePasswordVisibility: controller.togglePasswordVisibility,
                        onToggleConfirmPasswordVisibility: controller.toggleConfirmPasswordVisibility,
                        strength: controller.strength.value,
                        passwordsMatch: controller.passwordsMatch.value,
                        onPasswordChanged: controller.updatePassword,
                        onConfirmPasswordChanged: controller.updateConfirmPassword,
                      ),

                      // Warning Card (Protect mode only)
                      if (isProtect) const ProtectWarningCard(),

                      // Permissions & Security Options (Protect mode only)
                      if (isProtect)
                        ProtectPermissionsCard(
                          allowPrinting: controller.allowPrinting.value,
                          allowCopying: controller.allowCopying.value,
                          onPrintingChanged: controller.toggleAllowPrinting,
                          onCopyingChanged: controller.toggleAllowCopying,
                        ),
                    ],
                  ),
                ),
              ),

              // 4. Bottom Action Bar
              ProtectBottomBar(
                mode: mode,
                hasSelectedPdf: controller.selectedPdf.value != null,
                isFormValid: controller.isFormValid,
                isProcessing: controller.isProcessing.value,
                onAction: controller.executeSecurityAction,
              ),
            ],
          );
        }),
      ),
    );
  }
}
