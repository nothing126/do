// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme.dart';
import '../pages/login_page.dart';
import 'package:flutter_application_1/services/firebase_auth.dart'; // Import AuthenticationService

class ProfilePage extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthenticationService(); // Создаем экземпляр AuthenticationService

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
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!) // Используем аватар из Firebase
                : const AssetImage('assets/_1.png'), // Используем дефолтный аватар
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
                            builder:(context) => const LoginPage())),// MaterialPageRoute
                       child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.primary, // Цвет фона кнопки
                textStyle:  TextStyle(color: DoDidDoneTheme.lightTheme.colorScheme.secondary), // Цвет текста кнопки
              ),
              child: const Text('Подтвердить почту'),
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
