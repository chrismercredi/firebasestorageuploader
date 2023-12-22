import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class FileUtil {
  static IconData getIconForFileType(XFile file) {
    String fileExtension = _getFileExtension(file.name).toLowerCase();

    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image; // Images
      case 'doc':
      case 'docx':
        return Icons.description; // Word documents
      case 'xls':
      case 'xlsx':
        return Icons.table_chart; // Excel spreadsheets
      case 'ppt':
      case 'pptx':
        return Icons.slideshow; // PowerPoint presentations
      case 'pdf':
        return Icons.picture_as_pdf; // PDFs
      case 'svg':
        return Icons.brush; // SVGs
      case 'txt':
      case 'rtf':
        return Icons.notes; // Text and Rich Text Format
      default:
        return Icons.insert_drive_file; // Default icon for other file types
    }
  }

  static String _getFileExtension(String fileName) {
    return fileName.split('.').last;
  }
}
