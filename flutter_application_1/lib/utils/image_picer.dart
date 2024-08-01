// ignore_for_file: avoid_print

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  // Выбор изображения из галереи
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Качество изображения (0-100)
      );

      if (pickedImage != null) {
        return File(pickedImage.path);
      } else {
        return null;
      }
    } catch (e) {
      print('Ошибка при выборе изображения из галереи: $e');
      return null;
    }
  }

  // Сделать снимок
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Качество изображения (0-100)
      );

      if (pickedImage != null) {
        return File(pickedImage.path);
      } else {
        return null;
      }
    } catch (e) {
      print('Ошибка при съемке фотографии: $e');
      return null;
    }
  }
}

