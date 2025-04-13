import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PhotoFrameWidget extends StatefulWidget {
  const PhotoFrameWidget({super.key});

  @override
  PhotoFrameWidgetState createState() => PhotoFrameWidgetState();
}

class PhotoFrameWidgetState extends State<PhotoFrameWidget> {
  File? _croppedImage;

  Future<void> _pickAndCropImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        // aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Обрізати фото',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            lockAspectRatio: true,
          ),
        ],
      );

      if (cropped != null) {
        setState(() {
          _croppedImage = File(cropped.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _croppedImage != null
                    ? Image.file(
                  _croppedImage!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 250,
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 100),
                ),
              ),
              Image.asset(
                'assets/frames/frame1.png',
                width: 270,
                height: 270,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickAndCropImage,
            icon: const Icon(Icons.image),
            label: const Text('Вибрати фото'),
          ),
        ],
      ),
    );
  }
}
