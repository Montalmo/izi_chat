import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:izipizi_chat/screens/profile_screen.dart';
import 'package:izipizi_chat/utilits/pallets.dart';
import 'firebase_options.dart';

import '../utilits/themes.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initialFirebase();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IZIChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
        elevatedButtonTheme: elevatedButtonTheme,
        appBarTheme: appBarTheme,
        colorScheme: colorScheme,
        inputDecorationTheme: inputDecorationTheme,
        
        hintColor: PalletColors.cCyan600,
      ),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

_initialFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
