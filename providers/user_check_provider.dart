import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:storia/models/user_model/user_model.dart';
import 'package:storia/repositories/user_repository/user_repository.dart';

enum UserCheckStatus { idle, checking, ready, error }

final userCheckProvider =
    StateNotifierProvider<UserCheckNotifier, UserCheckStatus>(
      (ref) => UserCheckNotifier(ref),
    );

class UserCheckNotifier extends StateNotifier<UserCheckStatus> {
  UserCheckNotifier(this.ref) : super(UserCheckStatus.idle);

  final Ref ref;

  Future<void> check(User user, Map<String, dynamic> data) async {
    if (state != UserCheckStatus.idle) return;

    state = UserCheckStatus.checking;

    try {
      final userRep = UserRepository();
      final userModel = await userRep.get(user.uid);

      if (userModel == null) {
        bool hasImage = data['image'] != null;
        String? imageUrl;

        if (hasImage) {
          final imageBase64 = base64Encode(data['image']);
          final result = await FirebaseFunctions.instanceFor(
            region: 'southamerica-east1',
          ).httpsCallable('uploadImageV3').call({
            'type': 'avatar',
            'imageBase64': imageBase64,
          });

          imageUrl = result.data['url'];
        }

        final newUser = UserModel(
          name: user.displayName ?? data['name'],
          image: hasImage ? imageUrl : null,
          email: user.email,
          creationDate: DateTime.now(),
        );

        await userRep.create(newUser, user.uid);
      }

      state = UserCheckStatus.ready;
    } catch (_) {
      state = UserCheckStatus.error;
      rethrow;
    }
  }
}
