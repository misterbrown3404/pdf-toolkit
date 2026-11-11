import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'image_to_pdf_controller.dart';
import 'widgets/image_to_pdf_bottom_bar.dart';
import 'widgets/image_to_pdf_card_list.dart';
import 'widgets/image_to_pdf_header_banner.dart';
import 'widgets/image_to_pdf_settings_card.dart';
import 'widgets/image_to_pdf_success_view.dart';
import 'widgets/image_to_pdf_upload_card.dart';

class ImageToPdfView extends GetView<ImageToPdfController> {
  const ImageToPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.isSuccess.value) {
            return ImageToPdfSuccessView(controller: controller);
          }

          return Column(
            children: [
              // Header Banner with 3D Illustration & Back Button
              ImageToPdfHeaderBanner(onBack: () => Get.back()),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      if (controller.imageItems.isEmpty) ...[
                        ImageToPdfUploadCard(
                          onPickGallery: controller.pickFromGallery,
                          onTakePhoto: controller.takePhoto,
                          onLoadSamples: controller.loadSamplePhotos,
                        ),
                      ] else ...[
                        ImageToPdfCardList(
                          items: controller.imageItems,
                          onReorder: controller.reorderImages,
                          onRotate: controller.rotateImage,
                          onRemove: controller.removeImage,
                          onAddMoreGallery: controller.pickFromGallery,
                          onAddMoreCamera: controller.takePhoto,
                          onClearAll: controller.clearAllImages,
                        ),
                        ImageToPdfSettingsCard(
                          orientation: controller.pageOrientation.value,
                          pageSize: controller.pageSize.value,
                          margin: controller.pageMargin.value,
                          fitMode: controller.fitMode.value,
                          onOrientationChanged: controller.setOrientation,
                          onPageSizeChanged: controller.setPageSize,
                          onMarginChanged: controller.setMargin,
                          onFitModeChanged: controller.setFitMode,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom Sticky Conversion Bar
              ImageToPdfBottomBar(
                imageCount: controller.imageItems.length,
                isProcessing: controller.isProcessing.value,
                onConvert: controller.convertToPdf,
              ),
            ],
          );
        }),
      ),
    );
  }
}
