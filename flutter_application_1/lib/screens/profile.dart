// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme.dart';
import '../pages/login_page.dart';
import 'package:flutter_application_1/services/firebase_auth.dart'; // Import AuthenticationService
import 'package:flutter_application_1/utils/image_picer.dart'; // Import ImagePickerUtil
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; // Import Firebase Storage

class ProfileScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  final _authService = AuthenticationService(); // Создаем экземпляр AuthenticationService
  File? _selectedImage; // Переменная для хранения выбранного изображения

  // Функция для показа диалога выбора изображения
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите изображение'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Из галереи'),
                onTap: () async {
                  File? imageFile = await ImagePickerUtil.pickImageFromGallery();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать снимок'),
                onTap: () async {
                  File? imageFile = await ImagePickerUtil.pickImageFromCamera();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Функция для сохранения аватара в Firebase
  Future<void> _saveAvatarToFirebase() async {
    if (_selectedImage != null) {
      final user = _authService.getCurrentUser();
      if (user != null) {
        try {
          // Загружаем изображение в Firebase Storage
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('user_avatars/${user.uid}');
          final uploadTask = storageRef.putFile(_selectedImage!);
          await uploadTask.whenComplete(() async {
            // Получаем URL загруженного изображения
            final downloadURL = await storageRef.getDownloadURL();
            // Обновляем аватар пользователя в Firebase
            await user.updatePhotoURL(downloadURL);
            // Обновляем состояние, чтобы скрыть кнопку "Сохранить"
            setState(() {
              _selectedImage = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Аватар успешно сохранен.'))
            );
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Ошибка при сохранении аватара.')
          ));
          print('Ошибка при сохранении аватара: $e');
          // Обработайте ошибку (например, покажите сообщение пользователю)
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser(); // Получаем текущего пользователя

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          Stack(
            alignment: Alignment.bottomRight, // Выравнивание иконки внизу справа
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!) // Используем выбранное изображение
                    : user?.photoURL != null
                        ? NetworkImage(user!.photoURL!) // Используем аватар из Firebase
                        : const AssetImage('assets/_1.png'), // Используем дефолтный аватар
              ),
              IconButton(
                onPressed: () {
                  _showImagePickerDialog(context);
                },
                icon: const Icon(Icons.photo_camera),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Почта
          Text(
            user?.email ?? 'example@email.com', // Используем почту из Firebase
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (!user!.emailVerified)
            ElevatedButton(
              onPressed: () async {
                // Отправляем запрос на подтверждение почты
                await user.sendEmailVerification();
                // Показываем диалог с сообщением о том, что письмо отправлено
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage()), // MaterialPageRoute
                        ),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.primary, // Цвет фона кнопки
                textStyle: TextStyle(
                    color: DoDidDoneTheme.lightTheme.colorScheme.secondary), // Цвет текста кнопки
              ),
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),
          // Кнопка сохранения аватара (отображается, если выбрано новое изображение)
          if (_selectedImage != null)
            ElevatedButton(
              onPressed: _saveAvatarToFirebase,
              style: ElevatedButton.styleFrom(
                backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.primary, // Цвет фона кнопки
                textStyle: TextStyle(
                    color: DoDidDoneTheme.lightTheme.colorScheme.secondary), // Цвет текста кнопки
              ),
              child: const Text('Сохранить аватар'),
            ),
          const SizedBox(height: 20),
          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              // Выход из системы с помощью AuthenticationService
              await _authService.signOut();
              // Переход на страницу входа
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
              textStyle: const TextStyle(color: Colors.white), // Цвет текста кнопки
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
