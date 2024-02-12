import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:izipizi_chat/helper/dialogs.dart';

import 'package:svg_flutter/svg.dart';
import '../../api/api.dart';
import '../../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Future<UserCredential?> signInWithGoogle() async {
      try {
        await InternetAddress.lookup('google.com');
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        return await APIs.auth.signInWithCredential(credential);
      } catch (e) {
        log('\n _signInWithGoogle: $e');
        if (!context.mounted) return null;
        Dialogs.showErrorSnackBar(
            context, 'Something went wrong, Check internet connection!');
        return null;
      }
    }

    handleGoogleButtonClick() {
      Dialogs.showProgressBar(context);

      signInWithGoogle().then((user) async {
        Navigator.pop(context);
        if (user != null) {
          debugPrint('User: ${user.user}');
          debugPrint('User: ${user.additionalUserInfo}');

          if (await APIs.userExist()) {
            if (!context.mounted) return;
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          } else {
            await APIs.createUser().then((value) {
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to IZIChat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                'assets/images/logo_2x.png',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: ElevatedButton.icon(
                onPressed: handleGoogleButtonClick,
                icon: SvgPicture.asset(
                  'assets/svgs/google_logo.svg',
                ),
                label: const Text('Sing In with Google'),
              ),
            ),
            const SizedBox(
              height: 56.0,
            ),
          ],
        ),
      ),
    );
  }
}
