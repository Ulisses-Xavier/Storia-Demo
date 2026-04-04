// O provider que expõe o estado de autenticação do usuário
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/models/user_model/subs/saved_contents.dart';
import 'package:storia/models/user_model/user_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

final userDocumentProvider = StreamProvider<UserModel?>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return authAsync.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
            if (!doc.exists) return null;
            return UserModel.fromJson(doc.data()!);
          });
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

final savedContentsProvider = StreamProvider<List<SavedContentsModel>>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return authAsync.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_contents')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => SavedContentsModel.fromJson(doc.data()))
                .toList();
          });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
