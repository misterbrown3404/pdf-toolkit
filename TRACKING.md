# PDF Toolkit — Feature Roadmap & Progress Tracker

> **Core App Rule**: Strictly **ONE class per file** across all Dart files (`lib/` and `test/`).
> **Brand Identity**: Primary Orange `#F97316`, Warm Cream `#FFF7ED`, Surface Light `#FFFFFF`, Text Primary `#0F172A`, Plus Jakarta Sans typography.

---

## 📊 Summary Status

- **Total Major Features / Screens**: 15
- **Fully Completed & Tested**: 13 (Splash, Home, Merge PDF, Split PDF, Compress PDF, PDF to Image, Document Scanner, Image to PDF, Add Watermark, Protect & Unlock PDF, PDF Reader / Viewer, My Files Tab, All Tools Catalog)
- **Currently In Progress**: None (Ready for next selection)
- **Pending Implementation**: 2
- **Total Test Cases**: 99 (100% passing)
- **Static Analysis**: 0 issues (`flutter analyze` clean)
- **AST 1-Class-per-File Compliance**: 100% (167/167 files compliant)

---

## ✅ Completed Features

### 1. Splash Screen
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_app_splash_screen_in_portrai.png`
- **Key Files**:
  - [`lib/app/features/splash/splash_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/splash/splash_view.dart)
  - [`lib/app/features/splash/splash_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/splash/splash_controller.dart)
  - [`lib/app/features/splash/splash_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/splash/splash_binding.dart)
  - Extracted 3D asset: [`assets/images/splash_logo.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/splash_logo.png)
- **Capabilities**: Custom logo rendering, app title, subtitle, animated loading progress, route transition to Home.

### 2. Home Screen & Dashboard
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_polished_mobile_app_home_screen_dashboard_ui_f.png`
- **Key Files**:
  - [`lib/app/features/home/home_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/home/home_view.dart)
  - [`lib/app/features/home/widgets/home_header_app_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/home/widgets/home_header_app_bar.dart)
  - [`lib/app/features/home/widgets/home_hero_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/home/widgets/home_hero_banner.dart)
  - [`lib/app/features/home/widgets/home_tools_section.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/home/widgets/home_tools_section.dart)
  - [`lib/app/features/home/widgets/home_recent_files_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/home/widgets/home_recent_files_card.dart)
- **Tests**: [`test/home_features_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/home_features_test.dart)
- **Capabilities**: App bar with search/notifications, 3D hero promotional card, 3x2 quick tools grid, interactive recent files list with action menu, bottom navigation tabs.

### 3. Merge PDF
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_polished_mobile_app_screen_smartphone_ui_for_a.png`
- **Key Files**:
  - [`lib/app/features/merge_pdf/merge_pdf_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/merge_pdf_view.dart)
  - [`lib/app/features/merge_pdf/merge_pdf_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/merge_pdf_controller.dart)
  - [`lib/app/features/merge_pdf/widgets/merge_stepper_header.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/widgets/merge_stepper_header.dart)
  - [`lib/app/features/merge_pdf/widgets/merge_hero_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/widgets/merge_hero_card.dart)
  - [`lib/app/features/merge_pdf/widgets/merge_file_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/widgets/merge_file_card.dart)
  - [`lib/app/features/merge_pdf/widgets/merge_doc_thumbnail.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/merge_pdf/widgets/merge_doc_thumbnail.dart)
- **Tests**: [`test/merge_pdf_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/merge_pdf_test.dart)
- **Capabilities**: Step indicator (Add Files -> Reorder -> Merge), drag-to-reorder reorderable list, specialized document thumbnails, remove file actions, merge PDF generation, add to recent files, interstitial ad hook.

### 4. Split PDF
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_crisp_modern_mobile_app_ui_on_a_phone_screen_fo.png` & `assets/PDF_Toolkit_All_UI_Designs/a_polished_mobile_app_success_screen_in_the_same_o.png`
- **Key Files**:
  - [`lib/app/features/split_pdf/split_pdf_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/split_pdf_view.dart)
  - [`lib/app/features/split_pdf/split_pdf_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/split_pdf_controller.dart)
  - [`lib/app/features/split_pdf/widgets/split_file_header.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/widgets/split_file_header.dart)
  - [`lib/app/features/split_pdf/widgets/split_mode_selector.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/widgets/split_mode_selector.dart)
  - [`lib/app/features/split_pdf/widgets/split_range_input.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/widgets/split_range_input.dart)
  - [`lib/app/features/split_pdf/widgets/split_summary_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/widgets/split_summary_card.dart)
  - [`lib/app/features/split_pdf/widgets/split_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/split_pdf/widgets/split_success_view.dart)
  - Extracted 3D asset: [`assets/images/split_hero_docs.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/split_hero_docs.png)
- **Tests**: [`test/split_pdf_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/split_pdf_test.dart)
- **Capabilities**: Document upload/swap container, 3 split modes (Page Range, Extract All, Fixed Interval), preset chips (`1-5`, `6-10`, `All Odd`, `All Even`), custom interval inputs, real-time file estimate banner, multi-page subset PDF extraction (`PdfService.extractPages`), 3D twin documents success screen with direct preview & share.

### 5. Compress PDF
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_detailed_mobile_app_ui_screen_for_the_compress.png` & `assets/PDF_Toolkit_All_UI_Designs/a_smartphone_screen_ui_in_the_same_clean_orange_cr.png`
- **Key Files**:
  - [`lib/app/features/compress_pdf/compress_pdf_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/compress_pdf_view.dart)
  - [`lib/app/features/compress_pdf/compress_pdf_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/compress_pdf_controller.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_header_banner.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_file_picker_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_file_picker_card.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_level_selector.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_level_selector.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_estimate_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_estimate_card.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_more_options_sheet.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_more_options_sheet.dart)
  - [`lib/app/features/compress_pdf/widgets/compress_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/compress_pdf/widgets/compress_success_view.dart)
  - Extracted 3D assets: [`assets/images/compress_header_doc.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/compress_header_doc.png), [`assets/images/compress_success_hero.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/compress_success_hero.png)
- **Tests**: [`test/compress_pdf_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/compress_pdf_test.dart)
- **Capabilities**: 3D squeeze header illustration, document upload/swap card, 3-level quality cards (*Low*, *Balanced*, *High*), real-time byte estimate banner (`≈ 68% smaller`), advanced options bottom sheet, native compression engine (`PdfService.compressPdf()`), 3D celebration hero success screen with before/after comparison, savings banner, 4 quick actions (Open, Share, Files, Rename), Done and Compress Another PDF workflows.

### 6. PDF to Image
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_ui_in_the_same_orange_cream.png` & `assets/PDF_Toolkit_All_UI_Designs/a_polished_mobile_app_success_screen_same_phone_s.png`
- **Key Files**:
  - [`lib/app/features/pdf_to_image/pdf_to_image_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/pdf_to_image_view.dart)
  - [`lib/app/features/pdf_to_image/pdf_to_image_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/pdf_to_image_controller.dart)
  - [`lib/app/features/pdf_to_image/widgets/pdf_to_image_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/widgets/pdf_to_image_header_banner.dart)
  - [`lib/app/features/pdf_to_image/widgets/pdf_to_image_file_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/widgets/pdf_to_image_file_card.dart)
  - [`lib/app/features/pdf_to_image/widgets/pdf_to_image_settings_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/widgets/pdf_to_image_settings_card.dart)
  - [`lib/app/features/pdf_to_image/widgets/pdf_to_image_thumbnail_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/widgets/pdf_to_image_thumbnail_card.dart)
  - [`lib/app/features/pdf_to_image/widgets/pdf_to_image_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_to_image/widgets/pdf_to_image_success_view.dart)
  - Extracted 3D assets: [`assets/images/pdf_to_image_header.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/pdf_to_image_header.png), [`assets/images/pdf_to_image_success_hero.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/pdf_to_image_success_hero.png)
- **Tests**: [`test/pdf_to_image_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/pdf_to_image_test.dart)
- **Capabilities**: 3D PDF-to-photo header artwork, document upload/swap card, format switcher (*JPG* / *PNG*), quality segmented selector (*Low*, *Medium*, *High*), page range selector (*All Pages* vs *Custom Range* with presets and text input), native high-resolution renderer ([`PdfService.renderPdfToImages`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/core/services/pdf_service.dart)), 3D celebration hero success view with summary transition card, horizontal scrollable thumbnail strip with page index badges, full-screen image viewer dialog, and system share sheet.

### 7. Document Scanner
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_iphone_style_ui_screen_for_document_scan.png`, `assets/PDF_Toolkit_All_UI_Designs/a_clean_ui_screenshot_of_a_mobile_app_scan_to_pdf.png`, & `assets/PDF_Toolkit_All_UI_Designs/a_detailed_smartphone_app_ui_screenshot_a_modern.png`
- **Key Files**:
  - [`lib/app/features/scanner/scanner_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/scanner_view.dart)
  - [`lib/app/features/scanner/scanner_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/scanner_controller.dart)
  - [`lib/app/features/scanner/scanner_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/scanner_binding.dart)
  - [`lib/app/features/scanner/viewfinder_painter.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/viewfinder_painter.dart)
  - [`lib/app/features/scanner/models/scanned_page_model.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/models/scanned_page_model.dart)
  - [`lib/app/features/scanner/models/scanner_filter_item.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/models/scanner_filter_item.dart)
  - [`lib/app/features/scanner/utils/scanner_filter_matrix.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/utils/scanner_filter_matrix.dart)
  - [`lib/app/features/scanner/widgets/scanner_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_header_banner.dart)
  - [`lib/app/features/scanner/widgets/scanner_scan_line.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_scan_line.dart)
  - [`lib/app/features/scanner/widgets/scanner_camera_viewfinder.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_camera_viewfinder.dart)
  - [`lib/app/features/scanner/widgets/scanner_mode_selector.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_mode_selector.dart)
  - [`lib/app/features/scanner/widgets/scanner_bottom_controls.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_bottom_controls.dart)
  - [`lib/app/features/scanner/widgets/scanner_review_header.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_review_header.dart)
  - [`lib/app/features/scanner/widgets/scanner_document_preview_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_document_preview_card.dart)
  - [`lib/app/features/scanner/widgets/scanner_filter_selector.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_filter_selector.dart)
  - [`lib/app/features/scanner/widgets/scanner_toolbar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_toolbar.dart)
  - [`lib/app/features/scanner/widgets/scanner_bottom_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_bottom_bar.dart)
  - [`lib/app/features/scanner/widgets/scanner_review_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_review_view.dart)
  - [`lib/app/features/scanner/widgets/scanner_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/scanner/widgets/scanner_success_view.dart)
  - Extracted 3D assets: [`assets/images/scanner_header_art.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/scanner_header_art.png), [`assets/images/scanner_preview_art.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/scanner_preview_art.png)
- **Tests**: [`test/scanner_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/scanner_test.dart) (9 tests passing)
- **Capabilities**: Camera Viewfinder with 3D illustration banner, glowing orange corner anchor handles (`ViewfinderPainter`), animated laser scan beam (`ScannerScanLine`), Auto-detect / Manual toggle pill, overlaid zoom pills (`0.5x`, `1x`, `2x`), 4 scan modes (`Document`, `Batch Scan`, `ID Card`, `Whiteboard`), gallery picker, large shutter button, flash cycler (`Auto`/`On`/`Off`), Review & Enhance canvas with page counter pill `< Page 1 of N >`, real-time 60fps filter matrix enhancement (`Magic Color`, `Original`, `B&W Text`, `Grayscale`, `Warm/Eco`), page rotation (`90°`), auto-crop simulation, retake & delete actions, native multi-page A4 PDF compiler with rotation support ([`PdfService.imagesToPdf`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/core/services/pdf_service.dart)), automatic registration to Recent Files, and 3D celebration hero success view.

### 8. Image to PDF
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_close_up_mobile_app_ui_modern_rounded_smartpho.png` & `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_ui_showcase_with_the_title_at_top.png`
- **Key Files**:
  - [`lib/app/features/image_to_pdf/image_to_pdf_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/image_to_pdf_view.dart)
  - [`lib/app/features/image_to_pdf/image_to_pdf_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/image_to_pdf_controller.dart)
  - [`lib/app/features/image_to_pdf/image_to_pdf_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/image_to_pdf_binding.dart)
  - [`lib/app/features/image_to_pdf/models/image_to_pdf_item_model.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/models/image_to_pdf_item_model.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_header_banner.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_upload_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_upload_card.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_card_item.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_card_item.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_card_list.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_card_list.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_settings_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_settings_card.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_bottom_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_bottom_bar.dart)
  - [`lib/app/features/image_to_pdf/widgets/image_to_pdf_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/image_to_pdf/widgets/image_to_pdf_success_view.dart)
  - Custom assets: [`assets/images/image_to_pdf_header.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/image_to_pdf_header.png)
- **Tests**: [`test/image_to_pdf_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/image_to_pdf_test.dart) (8 tests passing)
- **Capabilities**: Upload drop container with gallery & camera photo pickers and sample photos loader, reorderable drag-to-reorder card list (`ImageToPdfCardList`), per-image rotation (`90°`), individual deletion and clear-all actions, layout settings (`Portrait` vs `Landscape`, `A4` vs `US Letter` vs `Fit to Image`, Margins `None` vs `Normal`, Image Fit `Contain` vs `Cover`), native PDF compiler with custom orientation, margins, and rotations ([`PdfService.imagesToPdf`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/core/services/pdf_service.dart)), Recent Files integration, and 3D celebration hero success view with 4 quick actions (`Open PDF`, `Share PDF`, `View in Files`, `Print / Export`).

### 9. Add Watermark
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_modern_mobile_app_screen_mockup_watermark_adde.png` & `assets/PDF_Toolkit_All_UI_Designs/a_modern_mobile_app_ui_success_screen_on_a_phone.png`
- **Key Files**:
  - [`lib/app/features/watermark/watermark_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/watermark_view.dart)
  - [`lib/app/features/watermark/watermark_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/watermark_controller.dart)
  - [`lib/app/features/watermark/watermark_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/watermark_binding.dart)
  - [`lib/app/features/watermark/models/watermark_config_model.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/models/watermark_config_model.dart)
  - [`lib/app/features/watermark/widgets/watermark_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_header_banner.dart)
  - [`lib/app/features/watermark/widgets/watermark_file_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_file_card.dart)
  - [`lib/app/features/watermark/widgets/watermark_preview_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_preview_card.dart)
  - [`lib/app/features/watermark/widgets/watermark_settings_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_settings_card.dart)
  - [`lib/app/features/watermark/widgets/watermark_bottom_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_bottom_bar.dart)
  - [`lib/app/features/watermark/widgets/watermark_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/watermark/widgets/watermark_success_view.dart)
  - Extracted 3D assets: [`assets/images/watermark_hero.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/watermark_hero.png)
- **Tests**: [`test/watermark_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/watermark_test.dart) (9 tests passing)
- **Capabilities**: Header with 3D illustration badge, document selector card supporting file browsing and recent documents quick pick, live interactive A4 preview card with real-time watermark stamping, configuration card with Text vs Image stamp switcher, 5 text presets (`CONFIDENTIAL`, `DRAFT`, `SAMPLE`, `DO NOT COPY`, `ORIGINAL`), custom text field, 5 color swatches, 3 angle presets (`Diagonal (-45°)`, `Horizontal (0°)`, `Vertical (90°)`), opacity slider (10% - 90%), font size slider (18pt - 72pt), 3 position modes (`Top`, `Center`, `Bottom`), native watermark engine (`PdfService.addWatermark`), and 3D celebration hero success view matching design mockup with View PDF, Share PDF, Add Another Watermark, Open File Location, and Back to Home.

### 10. Protect & Unlock PDF
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_mobile_app_ui_on_a_smartphone_screen_in_th.png` & `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_app_success_screen_in_the_sa.png`
- **Key Files**:
  - [`lib/app/features/protect_pdf/protect_pdf_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/protect_pdf_view.dart)
  - [`lib/app/features/protect_pdf/protect_pdf_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/protect_pdf_controller.dart)
  - [`lib/app/features/protect_pdf/protect_pdf_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/protect_pdf_binding.dart)
  - [`lib/app/features/protect_pdf/models/protect_mode_enum.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/models/protect_mode_enum.dart)
  - [`lib/app/features/protect_pdf/models/password_strength_model.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/models/password_strength_model.dart)
  - [`lib/app/features/protect_pdf/utils/password_strength_calculator.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/utils/password_strength_calculator.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_header_banner.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_mode_selector.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_mode_selector.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_file_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_file_card.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_password_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_password_card.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_warning_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_warning_card.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_permissions_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_permissions_card.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_bottom_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_bottom_bar.dart)
  - [`lib/app/features/protect_pdf/widgets/protect_success_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/protect_pdf/widgets/protect_success_view.dart)
  - Extracted 3D assets: [`assets/images/protect_header_art.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/protect_header_art.png), [`assets/images/protect_success_hero.png`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/assets/images/protect_success_hero.png)
- **Tests**: [`test/protect_pdf_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/protect_pdf_test.dart) (10 tests passing)
- **Capabilities**: Mode switcher between Protect PDF (add password) and Unlock PDF (permanently decrypt), document upload container with recent files quick-pick, password input with show/hide toggle, live 3-tier password strength meter, confirm password field with matching indicator pill, amber warning card for forgotten passwords, security permissions toggles (Allow Printing, Allow Copying Content), AES-256 bit encryption engine ([`PdfService.protectPdf`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/core/services/pdf_service.dart)), clean PDF decryption engine ([`PdfService.unlockPdf`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/core/services/pdf_service.dart)), Recent Files integration, and 3D celebration hero success screen matching design mockup with Open PDF, Share PDF, Protect Another PDF, and Back to Home.

### 11. PDF Reader / Viewer
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_app_ui_mockup_screenshot_f.png` & `assets/PDF_Toolkit_All_UI_Designs/a_detailed_polished_mobile_app_screenshot_ui_a_s.png`
- **Key Files**:
  - [`lib/app/features/pdf_viewer/pdf_viewer_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/pdf_viewer_view.dart)
  - [`lib/app/features/pdf_viewer/pdf_viewer_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/pdf_viewer_controller.dart)
  - [`lib/app/features/pdf_viewer/pdf_viewer_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/pdf_viewer_binding.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_header_app_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_header_app_bar.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_meta_ribbon.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_meta_ribbon.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_search_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_search_bar.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_bottom_controls.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_bottom_controls.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_page_jump_dialog.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_page_jump_dialog.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_tools_sheet.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_tools_sheet.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_password_dialog.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_password_dialog.dart)
  - [`lib/app/features/pdf_viewer/widgets/viewer_thumbnails_drawer.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/pdf_viewer/widgets/viewer_thumbnails_drawer.dart)
- **Tests**: [`test/pdf_viewer_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/pdf_viewer_test.dart) (9 tests passing)
- **Capabilities**: Curved header bar with circular back button, title, search toggle, night/dark reading mode, page thumbnail drawer, and system share button; document metadata ribbon with PDF red icon badge, file name, size & page count, and page badge (`1/10`); sliding search bar with match counter pill (`X/Y`), prev/next navigation, and close action; high-performance `pdfrx` document viewport with pinch-to-zoom and password provider for encrypted PDFs; floating bottom controls dock with zoom in, zoom out, page scrubber pill `< Page X of Y >`, prev/next page buttons, and PDF tools sheet; jump-to-page dialog with adaptive slider; page thumbnail drawer for instant visual jumping; and tools bottom sheet offering direct routes to Split, Merge, Compress, PDF to Image, Watermark, and Protect PDF.

### 12. My Files Tab
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_smartphone_app_ui_screenshot_style.png`, `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_ui_screen_for_files_in_th.png`, & `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_ui_screenshot_of_a_file_de.png`
- **Key Files**:
  - [`lib/app/features/files/files_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/files_view.dart)
  - [`lib/app/features/files/files_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/files_controller.dart)
  - [`lib/app/features/files/files_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/files_binding.dart)
  - [`lib/app/features/files/models/file_category_enum.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/models/file_category_enum.dart)
  - [`lib/app/features/files/models/file_sort_enum.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/models/file_sort_enum.dart)
  - [`lib/app/features/files/widgets/files_header_app_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_header_app_bar.dart)
  - [`lib/app/features/files/widgets/files_storage_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_storage_card.dart)
  - [`lib/app/features/files/widgets/files_category_chips.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_category_chips.dart)
  - [`lib/app/features/files/widgets/files_search_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_search_bar.dart)
  - [`lib/app/features/files/widgets/files_sort_bottom_sheet.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_sort_bottom_sheet.dart)
  - [`lib/app/features/files/widgets/files_document_tile.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_document_tile.dart)
  - [`lib/app/features/files/widgets/files_document_grid_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_document_grid_card.dart)
  - [`lib/app/features/files/widgets/files_details_bottom_sheet.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_details_bottom_sheet.dart)
  - [`lib/app/features/files/widgets/files_empty_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/files/widgets/files_empty_view.dart)
- **Tests**: [`test/files_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/files_test.dart) (18 tests passing)
- **Capabilities**: Custom AppBar with compact circular action triggers (Search, Sort, and Grid/List view toggle), Device Storage gauge card with storage breakdown and progress indicator, horizontal category filter chips with live document counts (`All Files`, `PDFs`, `Scanned`, `Compressed`, `Protected`), real-time search input bar with instant clear button, 6-option Sort modal bottom sheet (`Date Newest/Oldest`, `Name A-Z/Z-A`, `Size Largest/Smallest`), grouped chronological document list (`Today`, `Yesterday`, `Earlier`) and responsive 2-column Grid view, interactive `FilesDetailsBottomSheet` matching design mockups with file metadata (type, size in bytes, pages, modified date, security encryption status, path) and 9 quick action triggers (`Open in Viewer`, `Share`, `Rename`, `Duplicate`, `Protect`, `Watermark`, `Compress`, `Split`, `Delete`), empty state with quick PDF import, and file operations directly linked to native filesystem and `FileService`.

### 13. All Tools Catalog
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_modern_mobile_app_ui_on_a_smartphone_scree.png`
- **Key Files**:
  - [`lib/app/features/tools/tools_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/tools_view.dart)
  - [`lib/app/features/tools/tools_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/tools_controller.dart)
  - [`lib/app/features/tools/tools_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/tools_binding.dart)
  - [`lib/app/features/tools/models/tools_filter_category_enum.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/models/tools_filter_category_enum.dart)
  - [`lib/app/features/tools/widgets/tools_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_header_banner.dart)
  - [`lib/app/features/tools/widgets/tools_search_bar.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_search_bar.dart)
  - [`lib/app/features/tools/widgets/tools_category_filter_pills.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_category_filter_pills.dart)
  - [`lib/app/features/tools/widgets/tools_popular_section.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_popular_section.dart)
  - [`lib/app/features/tools/widgets/tools_grid_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_grid_card.dart)
  - [`lib/app/features/tools/widgets/tools_empty_state.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_empty_state.dart)
  - [`lib/app/features/tools/widgets/tools_pro_dialog.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/tools/widgets/tools_pro_dialog.dart)
- **Tests**: [`test/tools_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/tools_test.dart) (12 tests passing)
- **Capabilities**: PDF Tools header banner with `ALL-IN-ONE` badge pill, subtitle, and 3D PDF illustration; real-time tool search input bar with query matching and instant clear button; category filter chips with live counts (`All Tools`, `Organize`, `Convert`, `Security`, `Optimize`); Popular Tools section featuring 4 primary tools with active highlight border and View All action; 16 comprehensive tools mapped to native workflows; specialized Pro badge pills and interactive `ToolsProDialog` upgrade modal; and friendly empty search state with one-tap reset.

### 14. Settings Screen
- **Status**: Completed & Verified
- **Design Spec**: `assets/PDF_Toolkit_All_UI_Designs/a_clean_mobile_app_ui_screen_pdf_toolkit_settin.png` & `assets/PDF_Toolkit_All_UI_Designs/a_phone_ui_screenshot_of_a_settings_screen_for_a_p.png`
- **Key Files**:
  - [`lib/app/features/settings/settings_view.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/settings_view.dart)
  - [`lib/app/features/settings/settings_controller.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/settings_controller.dart)
  - [`lib/app/features/settings/settings_binding.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/settings_binding.dart)
  - [`lib/app/features/settings/widgets/settings_header_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_header_banner.dart)
  - [`lib/app/features/settings/widgets/settings_plan_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_plan_card.dart)
  - [`lib/app/features/settings/widgets/settings_pro_banner.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_pro_banner.dart)
  - [`lib/app/features/settings/widgets/settings_section_card.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_section_card.dart)
  - [`lib/app/features/settings/widgets/settings_tile.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_tile.dart)
  - [`lib/app/features/settings/widgets/settings_theme_dialog.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_theme_dialog.dart)
  - [`lib/app/features/settings/widgets/settings_about_dialog.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/lib/app/features/settings/widgets/settings_about_dialog.dart)
- **Tests**: [`test/settings_test.dart`](file:///Users/son_of_jibril/Annur-Work/Pdf%20Toolkit/test/settings_test.dart) (11 tests passing)
- **Capabilities**: Bold header banner with 3D orange gear artwork; profile squircle card indicating current plan status (*Free Plan* vs *Pro Lifetime*); warm cream Pro upgrade banner with CTA; App Settings section with theme picker modal (System, Light, Dark) persisted across sessions, notification switch, and language selector; PDF Options section with default compression toggle, password reminder toggle, watermark default, and page format selection; Storage & Files section with dynamic real-time cache size calculation and safe cache cleaner; Support & About section with Rate App, Help & Feedback, Privacy Policy dialog, and offline privacy guarantee About dialog.

---

## 🚧 In Progress

*None currently active. Select a feature from the roadmap below.*

---

## 📋 Upcoming Features & Roadmap

| # | Feature / Screen | Target UI Designs | Key Components to Build | Priority |
|---|---|---|---|---|
| **15** | **Premium Paywall** | `a_clean_modern_mobile_app_ui_of_a_upgrade_to_pre.png`<br>`a_mobile_app_premium_activated_success_screen_in.png` | Feature comparison matrix, monthly/annual toggle with savings badge, restore purchases, 3D crown celebration screen | Medium |

---

## 🛠️ Verification Checklist (Enforced on Every Feature)
- [x] Strict 1-class-per-file across all `.dart` files
- [x] Zero static analysis warnings (`flutter analyze`)
- [x] All unit & widget tests pass (`flutter test`)
- [x] Hot reload / hot restart verified via `dart-mcp-server`
- [x] Zero runtime errors via `get_runtime_errors`
- [x] Live iOS simulator screenshot captured and visually verified
