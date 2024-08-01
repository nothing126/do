import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile.dart';
import '../theme/theme.dart';
import 'package:flutter_application_1/pages/main_page.dart'; // Import MainPage
import 'package:flutter_application_1/services/firebase_auth.dart'; // Import AuthenticationService

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
         backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, 
  
      ) ,
      body: SingleChildScrollView(
        child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,  
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: 
                  [
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      DoDidDoneTheme.lightTheme.colorScheme.primary,
                    ],
              stops: const [0.1, 0.9], // Основной цвет занимает 90%
            ),
          ),
          child: const ProfileScreen(),
        )
      ),
    );
  }
}
