import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storia/models/names_model.dart';
import 'package:storia/repositories/names_repository.dart';
import 'package:storia/repositories/user_repository/user_repository.dart';

final authServiceProvider = AsyncNotifierProvider<AuthService, void>(
  AuthService.new,
);

class AuthService extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // nada aqui
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();
      // Abre seletor de conta
      final GoogleSignInAccount account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication auth = account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        return false;
      }

      final userDoc = await UserRepository().get(user.uid);

      if (userDoc == null) {
        try {
          await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
              .httpsCallable('userCreation')
              .call({'name': user.displayName, 'image': user.photoURL});
        } catch (_) {
          await FirebaseAuth.instance.currentUser!.delete();
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createUser(
    String name,
    String email,
    String password,
    Uint8List? image,
  ) async {
    try {
      final auth = FirebaseAuth.instance;

      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? imageUrl;

      if (image != null) {
        try {
          final image64 = base64Encode(image);
          final function = FirebaseFunctions.instanceFor(
            region: "southamerica-east1",
          ).httpsCallable('uploadImageV3');

          final result = await function.call({
            'imageBase64': image64,
            'type': 'avatar',
          });

          final ok = result.data['success'];

          if (ok) {
            await credential.user!.updatePhotoURL(result.data['url']);
            imageUrl = result.data['url'];
          }
        } catch (_) {}
      }

      try {
        final result = await FirebaseFunctions.instanceFor(
          region: "southamerica-east1",
        ).httpsCallable('userCreation').call({
          'name': name.toLowerCase(),
          'image': imageUrl,
        });
        await credential.user!.updateDisplayName(name.toLowerCase());
        await NamesRepository().create(
          NamesModel(uid: result.data['id']),
          name.toLowerCase(),
        );
        return true;
      } catch (_) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
        }
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
