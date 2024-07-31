// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Метод для регистрации с помощью email и пароля
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // 1. Регистрируем пользователя в Firebase
      final UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Отправляем запрос на подтверждение почты
      await userCredential?.user?.sendEmailVerification();

      return userCredential;
    } catch (e) {
      print('Ошибка регистрации: $e');
      return null;
    }
  }

  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // 1. Входим в Firebase с помощью email и пароля
      final UserCredential? userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } catch (e) {
      print('Ошибка входа с помощью email и пароля: $e');
      return null;
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Ошибка выхода из системы: $e');
    }
  }

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
