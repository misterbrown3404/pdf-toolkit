import 'package:get/get.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';

class HomeController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  final FileService fileService = Get.find<FileService>();
  final AdsService adsService = Get.find<AdsService>();

  final RxInt currentTabIndex = 0.obs;
  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;
  final RxList<PdfDocumentModel> savedDocuments = <PdfDocumentModel>[].obs;
  final RxBool isLoadingFiles = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentTabIndex.value = 0;
    initFiles();
  }

  Future<void> initFiles() async {
    refreshAllFiles();
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    if (index == 2) {
      loadSavedDocuments();
    }
  }

  Future<void> refreshAllFiles() async {
    loadRecentFiles();
    loadSavedDocuments();
  }

  void loadRecentFiles() {
    final rawList = storageService.getRecentFiles();
    final models = rawList.map((e) => PdfDocumentModel.fromMap(e)).toList();
    recentFiles.assignAll(models);
  }

  Future<void> loadSavedDocuments() async {
    isLoadingFiles.value = true;
    try {
      final docs = await fileService.getSavedDocuments();
      savedDocuments.assignAll(docs);
    } finally {
      isLoadingFiles.value = false;
    }
  }

  Future<void> openPdfPicker() async {
    final doc = await fileService.pickSinglePdf();
    if (doc != null) {
      loadRecentFiles();
      Get.toNamed(
        AppRoutes.pdfViewer,
        arguments: {'path': doc.path, 'title': doc.name},
      );
    }
  }

  void openPdfDocument(PdfDocumentModel doc) {
    Get.toNamed(
      AppRoutes.pdfViewer,
      arguments: {'path': doc.path, 'title': doc.name},
    );
  }

  Future<void> shareFile(String path, String name) async {
    await fileService.shareFile(path, subject: name);
  }

  Future<void> removeRecent(String path) async {
    await storageService.removeRecentFile(path);
    loadRecentFiles();
  }

  void onToolTap(String route) {
    Get.toNamed(route);
  }
}
