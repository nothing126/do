import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:flutter_application_1/pages/main_page.dart'; // Import MainPage
import 'package:flutter_application_1/services/firebase_auth.dart'; // Import AuthenticationService

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthenticationService(); // Создаем экземпляр AuthenticationService

  @override
  void initState() {
    super.initState();
    isLogin = true; // Initialize isLogin to true
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,  
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: isLogin
                  ? [
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      DoDidDoneTheme.lightTheme.colorScheme.primary,
                    ]
                  : [
                      DoDidDoneTheme.lightTheme.colorScheme.primary,
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    ],
              stops: const [0.1, 0.9], // Основной цвет занимает 90%
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/0qode_symbol_1.png', // Замените на правильный путь к файлу
                        height: 50, // Устанавливаем высоту изображения
                      ),
                      const SizedBox(width: 7),
                      // Добавляем текст "zerocoder"
                      const Text(
                        'zerocoder',
                        style: TextStyle(
                          fontSize: 62,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Белый цвет текста
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Добавляем текст "Do"
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Do',
                          style: TextStyle(
                            color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(
                          text: 'Did',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Done',
                          style: TextStyle(
                            color: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Заголовок
                  Text(
                    isLogin ? 'Вход' : 'Регистрация',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Поле логина/почты
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Почта',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите почту';
                      }
                      if (!value.contains('@')) {
                        return 'Некорректный формат почты';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Поле пароля
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Пароль',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // **Новое поле "Повторить пароль"**
                  if (!isLogin) // Отображаем только при регистрации
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Повторить пароль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, повторите пароль';
                        }
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 30),
                  // Кнопка "Войти"
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isLogin) {
                          // Вход с помощью email и пароля
                          final userCredential = await _authService
                              .signInWithEmailAndPassword(
                                  _emailController.text, _passwordController.text);
                          if (userCredential != null) {
                            // Переход на главную страницу
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()));
                          }
                        } else {
                          // Регистрация с помощью email и пароля
                          final userCredential = await _authService
                              .registerWithEmailAndPassword(
                                  _emailController.text, _passwordController.text);
                          if (userCredential != null) {
                            // Переход на главную страницу
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()));
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isLogin
                          ? DoDidDoneTheme.lightTheme.colorScheme.secondary
                          : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20, color: Colors.white), // Добавили цвет текста
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                  ),
                  const SizedBox(height: 20),
                  // Кнопка перехода на другую страницу
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'У меня ещё нет аккаунта...'
                          : 'Уже есть аккаунт...',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
