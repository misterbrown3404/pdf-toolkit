import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';
import 'models/password_strength_model.dart';
import 'models/protect_mode_enum.dart';
import 'utils/password_strength_calculator.dart';

class ProtectPdfController extends GetxController {
  final FileService? _injectedFileService;
  final PdfService? _injectedPdfService;
  final StorageService? _injectedStorageService;

  ProtectPdfController({
    FileService? fileService,
    PdfService? pdfService,
    StorageService? storageService,
  })  : _injectedFileService = fileService,
        _injectedPdfService = pdfService,
        _injectedStorageService = storageService;

  FileService? get _fileService =>
      _injectedFileService ?? (Get.isRegistered<FileService>() ? Get.find<FileService>() : null);
  PdfService? get _pdfService =>
      _injectedPdfService ?? (Get.isRegistered<PdfService>() ? Get.find<PdfService>() : null);
  StorageService? get _storageService =>
      _injectedStorageService ?? (Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null);
  AdsService? get _adsService =>
      Get.isRegistered<AdsService>() ? Get.find<AdsService>() : null;

  final Rx<ProtectMode> mode = ProtectMode.protect.obs;
  final Rx<PdfDocumentModel?> selectedPdf = Rx<PdfDocumentModel?>(null);
  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;

  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final RxBool isPasswordObscured = true.obs;
  final RxBool isConfirmPasswordObscured = true.obs;

  final Rx<PasswordStrengthModel> strength = const PasswordStrengthModel(
    score: 0,
    label: '',
    color: Colors.transparent,
  ).obs;

  final RxBool passwordsMatch = false.obs;
  final RxBool allowPrinting = true.obs;
  final RxBool allowCopying = true.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isSuccess = false.obs;

  final RxString generatedPdfPath = ''.obs;
  final RxInt generatedPdfSize = 0.obs;
  final RxInt generatedPdfPages = 0.obs;

  bool get isFormValid {
    if (selectedPdf.value == null) return false;
    final pwd = passwordController.text;
    if (pwd.isEmpty) return false;

    if (mode.value == ProtectMode.protect) {
      final confirm = confirmPasswordController.text;
      return confirm.isNotEmpty && pwd == confirm;
    } else {
      return pwd.isNotEmpty;
    }
  }

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _loadRecentDocuments();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> _loadRecentDocuments() async {
    try {
      if (_fileService != null) {
        await _fileService!.ensureSampleDocuments();
        final docs = await _fileService!.getSavedDocuments();
        recentFiles.assignAll(docs);

        // Pre-select document if passed in route arguments
        if (Get.arguments is Map && Get.arguments['path'] != null) {
          final path = Get.arguments['path'] as String;
          final file = File(path);
          if (await file.exists()) {
            final doc = docs.firstWhereOrNull((d) => d.path == path) ??
                PdfDocumentModel(
                  id: path,
                  name: file.uri.pathSegments.last,
                  path: path,
                  sizeInBytes: await file.length(),
                  modifiedAt: DateTime.now(),
                );
            selectedPdf.value = doc;
          }
        } else if (docs.isNotEmpty && selectedPdf.value == null) {
          selectedPdf.value = docs.first;
        }
      }
    } catch (_) {}
  }

  void setMode(ProtectMode newMode) {
    if (mode.value != newMode) {
      mode.value = newMode;
      passwordController.clear();
      confirmPasswordController.clear();
      strength.value = const PasswordStrengthModel(score: 0, label: '', color: Colors.transparent);
      passwordsMatch.value = false;
    }
  }

  Future<void> pickPdf() async {
    try {
      final file = await _fileService?.pickSinglePdf();
      if (file != null) {
        selectedPdf.value = file;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select PDF: $e');
    }
  }

  void selectRecentPdf(PdfDocumentModel doc) {
    selectedPdf.value = doc;
  }

  void clearPdf() {
    selectedPdf.value = null;
  }

  void updatePassword(String val) {
    strength.value = PasswordStrengthCalculator.calculate(val);
    _checkPasswordMatch();
  }

  void updateConfirmPassword(String val) {
    _checkPasswordMatch();
  }

  void _checkPasswordMatch() {
    final p1 = passwordController.text;
    final p2 = confirmPasswordController.text;
    passwordsMatch.value = p1.isNotEmpty && p2.isNotEmpty && p1 == p2;
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  void toggleAllowPrinting(bool val) {
    allowPrinting.value = val;
  }

  void toggleAllowCopying(bool val) {
    allowCopying.value = val;
  }

  Future<void> executeSecurityAction() async {
    final pdf = selectedPdf.value;
    if (pdf == null) {
      Get.snackbar('Notice', 'Please select a PDF document first.');
      return;
    }

    final pwd = passwordController.text;
    if (pwd.isEmpty) {
      Get.snackbar('Notice', 'Please enter a password.');
      return;
    }

    if (mode.value == ProtectMode.protect) {
      final confirm = confirmPasswordController.text;
      if (pwd != confirm) {
        Get.snackbar('Validation', 'Passwords do not match.');
        return;
      }
    }

    try {
      isProcessing.value = true;
      final pdfService = _pdfService;
      if (pdfService == null) {
        throw StateError('PdfService not available');
      }

      String outputPath;
      if (mode.value == ProtectMode.protect) {
        outputPath = await pdfService.protectPdf(
          inputPath: pdf.path,
          userPassword: pwd,
          allowPrinting: allowPrinting.value,
          allowCopying: allowCopying.value,
        );
      } else {
        outputPath = await pdfService.unlockPdf(
          inputPath: pdf.path,
          password: pwd,
        );
      }

      final outputFile = File(outputPath);
      final size = await outputFile.length();

      // Register with Recent Files
      await _storageService?.addRecentFile({
        'path': outputPath,
        'name': p.basename(outputPath),
        'size': size,
        'pageCount': pdf.pageCount ?? 1,
        'createdAt': DateTime.now().toIso8601String(),
        'modifiedAt': DateTime.now().toIso8601String(),
      });

      generatedPdfPath.value = outputPath;
      generatedPdfSize.value = size;
      generatedPdfPages.value = pdf.pageCount ?? 1;
      isSuccess.value = true;
      _adsService?.showInterstitialIfReady();
    } catch (e) {
      Get.snackbar('Security Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isProcessing.value = false;
    }
  }

  void openPdf() {
    if (generatedPdfPath.value.isNotEmpty) {
      Get.toNamed(
        AppRoutes.pdfViewer,
        arguments: {
          'filePath': generatedPdfPath.value,
          'password': mode.value == ProtectMode.protect ? passwordController.text : null,
        },
      );
    }
  }

  Future<void> sharePdf() async {
    if (generatedPdfPath.value.isNotEmpty) {
      await _fileService?.shareFile(
        generatedPdfPath.value,
        subject: mode.value == ProtectMode.protect
            ? 'Protected PDF Document'
            : 'Unlocked PDF Document',
      );
    }
  }

  void reset() {
    isSuccess.value = false;
    passwordController.clear();
    confirmPasswordController.clear();
    strength.value = const PasswordStrengthModel(score: 0, label: '', color: Colors.transparent);
    passwordsMatch.value = false;
    generatedPdfPath.value = '';
    generatedPdfSize.value = 0;
    generatedPdfPages.value = 0;
  }
}
