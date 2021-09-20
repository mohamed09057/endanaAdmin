import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:endanaAdmin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
const scaffoldBackgroundColor = Color(0xFFffffff);
const textColor = Color(0xFF898989);
const buttomColor = Color(0xFFf0a528);
const notificationColor = Color(0xFF01af40);
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/logo.png'),
        nextScreen: LoginScreen(),
        splashTransition: SplashTransition.fadeTransition,
        centered: true,
      ),
    );
  }
}
