import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class ImageStorageService {
  static const _folderName = 'images';

  /// Зберігає зображення (у форматі PNG) в локальну директорію
  Future<String?> saveImage(Uint8List imageBytes) async {
    try {
      final directory = await _getLocalDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      return file.path;
    } catch (e) {
      print('❌ Save image error: $e');
      return null;
    }
  }

  /// Отримує список усіх зображень у директорії
  Future<List<File>> getAllImages() async {
    final directory = await _getLocalDirectory();
    final List<FileSystemEntity> files = directory.listSync();
    return files.whereType<File>().toList();
  }

  /// Видаляє зображення за шляхом
  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Delete image error: $e');
      return false;
    }
  }

  /// Видаляє всі зображення
  Future<void> clearAllImages() async {
    final files = await getAllImages();
    for (var file in files) {
      await file.delete();
    }
  }

  /// Отримує директорію зображень
  Future<Directory> _getLocalDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/$_folderName');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }
}
