import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
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
  ];

  static List<ToolItemModel> get homeGridTools =>
      allTools.where((t) => ['merge', 'split', 'compress', 'pdf_to_image', 'image_to_pdf', 'more_tools'].contains(t.id)).toList();
}
