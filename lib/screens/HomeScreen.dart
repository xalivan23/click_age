import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final String _prefsKey = 'saved_image_path';

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  /// Завантаження збереженого шляху до зображення
  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_prefsKey);

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _selectedImage = File(imagePath);
      });
    }
  }

  /// Вибір та збереження нового зображення
  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      final oldPath = prefs.getString(_prefsKey);

      // Видаляємо старий файл
      if (oldPath != null && File(oldPath).existsSync()) {
        await File(oldPath).delete();
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(picked.path);
      final savedImage = await File(picked.path).copy('${directory.path}/$fileName');

      // Зберігаємо новий шлях
      await prefs.setString(_prefsKey, savedImage.path);

      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Обери свій тотем')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : const AssetImage('assets/images/my_image_1.jpg') as ImageProvider,
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _pickAndSaveImage,
              icon: const Icon(Icons.photo),
              label: const Text('Завантажити зображення'),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game', arguments: _selectedImage?.path);
              },
              child: const Text('Продовжити до гри'),
            ),
          ],
        ),
      ),
    );
  }
}
