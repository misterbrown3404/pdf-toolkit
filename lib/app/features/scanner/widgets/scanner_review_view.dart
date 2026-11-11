import 'package:flutter/material.dart';
import '../scanner_controller.dart';
import 'scanner_bottom_bar.dart';
import 'scanner_document_preview_card.dart';
import 'scanner_filter_selector.dart';
import 'scanner_review_header.dart';
import 'scanner_toolbar.dart';

class ScannerReviewView extends StatelessWidget {
  final ScannerController controller;

  const ScannerReviewView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Review App Bar with Page Stepper
        ScannerReviewHeader(controller: controller),

        // Central High-Res Document Preview Canvas
        Expanded(
          child: ScannerDocumentPreviewCard(controller: controller),
        ),

        // Filter Strip Selector
        ScannerFilterSelector(controller: controller),

        // Quick Editing Tools (Rotate, Crop, Retake, Delete)
        ScannerToolbar(controller: controller),

        // Bottom Save as PDF & Share Bar
        ScannerBottomBar(controller: controller),
      ],
    );
  }
}

