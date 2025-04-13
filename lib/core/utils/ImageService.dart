import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Вибір зображення з камери або галереї
  Future<File?> pickImage({bool fromCamera = false}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// Обрізка зображення
  Future<File?> cropImage(File imageFile) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // cropStyle: CropStyle.rectangle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Обрізати',
          toolbarColor: Colors.brown,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Обрізати',
        ),
      ],
    );
    return cropped != null ? File(cropped.path) : null;
  }


  /// Стиснення зображення
  Future<XFile?> compressImage(File imageFile, {int quality = 85}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.path, "compressed_${p.basename(imageFile.path)}");

    final compressed = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: quality,
    );
    return compressed;
  }

  /// Збереження у локальну директорію
  Future<File> saveImage(File imageFile, {String folder = "images"}) async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = p.join(directory.path, folder);
    await Directory(folderPath).create(recursive: true);

    final String fileName = "img_${DateTime.now().millisecondsSinceEpoch}.png";
    final String path = p.join(folderPath, fileName);
    return await imageFile.copy(path);
  }

  /// Видалення зображення
  Future<void> deleteImage(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Отримати список усіх збережених зображень у директорії
  Future<List<File>> listSavedImages({String folder = "images"}) async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = p.join(directory.path, folder);
    final dir = Directory(folderPath);
    if (!await dir.exists()) return [];
    final files = dir.listSync().whereType<File>().toList();
    return files;
  }
}
