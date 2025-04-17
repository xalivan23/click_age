import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
    final hasImage = imagePath != null && File(imagePath).existsSync();

    return Scaffold(
      appBar: AppBar(title: const Text('name of hero')),
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
          const Text('totrm: 🐺'),

          const SizedBox(height: 20),

          // Показники
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              Text(AppLocalizations.of(context)!.life),
              Text(AppLocalizations.of(context)!.armor),
              Text(AppLocalizations.of(context)!.strength),
              Text(AppLocalizations.of(context)!.food),
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
                ElevatedButton(onPressed: () {}, child:  Text(AppLocalizations.of(context)!.feeding)),
                ElevatedButton(onPressed: () {}, child:  Text(AppLocalizations.of(context)!.sleep)),
                ElevatedButton(onPressed: () {}, child:  Text(AppLocalizations.of(context)!.training)),
                ElevatedButton(onPressed: () {}, child:  Text(AppLocalizations.of(context)!.hunting)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
