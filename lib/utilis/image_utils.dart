import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Function to get image from gallery
  static Future<File?> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Function to get image from camera
  static Future<File?> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Function to show options for selecting image
  static Future<void> showOptions(BuildContext context, Function(File) onImageSelected) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).colorScheme.secondary,
            child: SizedBox(
              height: 150,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      File? image = await getImageFromCamera();
                      if (image != null) {
                        onImageSelected(image);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      File? image = await getImageFromGallery();
                      if (image != null) {
                        onImageSelected(image);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
