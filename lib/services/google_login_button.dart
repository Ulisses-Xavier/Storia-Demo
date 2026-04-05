import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/utilities/utilities.dart';

class GoogleLoginButton extends ConsumerStatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  ConsumerState<GoogleLoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends ConsumerState<GoogleLoginButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      text: "Login com Google",
      isSelected: false,
      isLoading: _isLoading,
      loadingSize: 0.5,
      loadingColor: Colors.black,
      width: 350,
      height: 40.0,
      paddingCentral: 15.0,
      alignment: MainAxisAlignment.center,
      onHover: const Color.fromARGB(255, 234, 234, 234),
      fontSize: 15.0,
      color: Colors.white,
      textColor: Colors.black,
      borderRadius: 10.0,
      splashColor: const Color.fromARGB(255, 216, 216, 216),
      image: _isLoading ? null : 'assets/images/google_logo.png',
      imageSize: 20,
      onTap: () async {
        if (_isLoading) return;
        setState(() {
          _isLoading = true;
        });
        try {
          GoogleAuthProvider googleProvider = GoogleAuthProvider();

          googleProvider.addScope(
            'https://www.googleapis.com/auth/userinfo.profile',
          );
          googleProvider.addScope(
            'https://www.googleapis.com/auth/userinfo.email',
          );
          googleProvider.setCustomParameters({
            'login_hint': 'user@example.com',
          });

          await FirebaseAuth.instance.signInWithPopup(googleProvider);
          setState(() {
            _isLoading = false;
          });
        } catch (_) {
          setState(() {
            _isLoading = false;
          });
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }
}
