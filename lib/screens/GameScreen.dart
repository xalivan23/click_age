import 'dart:io';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
    final hasImage = imagePath != null && File(imagePath).existsSync();

    return Scaffold(
      appBar: AppBar(title: const Text('Твій герой')),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Фото користувача або дефолтна
          CircleAvatar(
            radius: 50,
            backgroundImage: hasImage
                ? FileImage(File(imagePath!))
                : const AssetImage('assets/images/my_image_1.jpg') as ImageProvider,
          ),
          const SizedBox(height: 10),
          const Text('Тотем: 🐺'),

          const SizedBox(height: 20),

          // Показники
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('❤️ Життя: 80'),
              Text('🛡️ Броня: 40'),
              Text('💪 Сила: 70'),
              Text('🍖 Їжа: 60'),
            ],
          ),

          const SizedBox(height: 40),

          // Кнопки дій
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('🍽 Харчування')),
                ElevatedButton(onPressed: () {}, child: const Text('😴 Сон')),
                ElevatedButton(onPressed: () {}, child: const Text('🏋️‍♂️ Тренування')),
                ElevatedButton(onPressed: () {}, child: const Text('🏹 Полювання')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
