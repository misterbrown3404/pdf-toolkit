import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../models/tool_category_enum.dart';
import '../models/tool_item_model.dart';

class ToolsCatalog {
  ToolsCatalog._();

  static const List<ToolItemModel> allTools = [
    ToolItemModel(
      id: 'merge',
      title: 'Merge PDF',
      description: 'Combine multiple PDFs into one unified document',
      icon: Icons.layers_rounded,
      color: Color(0xFFF97316), // Brand Orange
      route: AppRoutes.mergePdf,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'split',
      title: 'Split PDF',
      description: 'Separate pages or extract specific ranges',
      icon: Icons.content_cut_rounded,
      color: Color(0xFF8B5CF6), // Purple
      route: AppRoutes.splitPdf,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'compress',
      title: 'Compress PDF',
      description: 'Reduce file size while preserving quality',
      icon: Icons.compress_rounded,
      color: Color(0xFF10B981), // Green
      route: AppRoutes.compressPdf,
      category: ToolCategory.optimize,
    ),
    ToolItemModel(
      id: 'pdf_to_image',
      title: 'PDF to Image',
      description: 'Extract PDF pages as high-quality image files',
      icon: Icons.image_rounded,
      color: Color(0xFF3B82F6), // Blue
      route: AppRoutes.pdfToImage,
      category: ToolCategory.convert,
    ),
    ToolItemModel(
      id: 'image_to_pdf',
      title: 'Image to PDF',
      description: 'Convert JPG, PNG, and photos into a PDF',
      icon: Icons.picture_as_pdf_rounded,
      color: Color(0xFFEF4444), // PDF Red
      route: AppRoutes.imageToPdf,
      category: ToolCategory.convert,
    ),
    ToolItemModel(
      id: 'more_tools',
      title: 'More Tools',
      description: 'Watermark, scanner, password encryption & more',
      icon: Icons.grid_view_rounded,
      color: Color(0xFF6366F1), // Violet
      route: AppRoutes.tools,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'scanner',
      title: 'Scan to PDF',
      description: 'Camera scanner with perspective correction',
      icon: Icons.document_scanner_rounded,
      color: Color(0xFFF97316),
      route: AppRoutes.scanner,
      category: ToolCategory.scan,
      isNew: true,
    ),
    ToolItemModel(
      id: 'watermark',
      title: 'Add Watermark',
      description: 'Stamp custom text or confidential stamps',
      icon: Icons.branding_watermark_rounded,
      color: Color(0xFFEC4899),
      route: AppRoutes.watermark,
      category: ToolCategory.security,
    ),
    ToolItemModel(
      id: 'protect',
      title: 'Protect PDF',
      description: 'Encrypt documents with AES-256 password',
      icon: Icons.lock_outline_rounded,
      color: Color(0xFFEF4444),
      route: AppRoutes.protectPdf,
      category: ToolCategory.security,
    ),
    ToolItemModel(
      id: 'unlock',
      title: 'Unlock PDF',
      description: 'Permanently remove PDF password protection',
      icon: Icons.lock_open_rounded,
      color: Color(0xFF10B981),
      route: AppRoutes.protectPdf,
      category: ToolCategory.security,
    ),
    ToolItemModel(
      id: 'viewer',
      title: 'PDF Reader',
      description: 'View documents with search, night mode & dock',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFE11D48),
      route: AppRoutes.pdfViewer,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'rotate',
      title: 'Rotate PDF',
      description: 'Rotate document pages in 90° increments',
      icon: Icons.rotate_right_rounded,
      color: Color(0xFF8B5CF6),
      route: AppRoutes.pdfViewer,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'reorder',
      title: 'Reorder Pages',
      description: 'Rearrange and organize pages in your PDF',
      icon: Icons.swap_vert_circle_outlined,
      color: Color(0xFFF43F5E),
      route: AppRoutes.mergePdf,
      category: ToolCategory.organize,
    ),
    ToolItemModel(
      id: 'pdf_to_word',
      title: 'PDF to Word',
      description: 'Convert PDF documents into editable Word (.docx)',
      icon: Icons.description_rounded,
      color: Color(0xFF2563EB),
      route: AppRoutes.premium,
      category: ToolCategory.convert,
      isPremium: true,
    ),
    ToolItemModel(
      id: 'pdf_to_excel',
      title: 'PDF to Excel',
      description: 'Extract tables and data into Excel spreadsheets',
      icon: Icons.table_chart_rounded,
      color: Color(0xFF059669),
      route: AppRoutes.premium,
      category: ToolCategory.convert,
      isPremium: true,
    ),
    ToolItemModel(
      id: 'pdf_to_powerpoint',
      title: 'PDF to PPT',
      description: 'Convert presentation slides into PowerPoint',
      icon: Icons.slideshow_rounded,
      color: Color(0xFFEA580C),
      route: AppRoutes.premium,
      category: ToolCategory.convert,
      isPremium: true,
    ),
    ToolItemModel(
      id: 'edit_pdf',
      title: 'Edit PDF',
      description: 'Annotate, draw, and modify PDF text content',
      icon: Icons.edit_note_rounded,
      color: Color(0xFF7C3AED),
      route: AppRoutes.pdfViewer,
      category: ToolCategory.organize,
      isPremium: true,
    ),
  ];

  static List<ToolItemModel> get homeGridTools =>
      allTools.where((t) => ['merge', 'split', 'compress', 'pdf_to_image', 'image_to_pdf', 'more_tools'].contains(t.id)).toList();
}
