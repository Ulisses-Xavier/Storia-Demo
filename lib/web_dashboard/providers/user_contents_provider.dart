import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/providers/auth_state_provider.dart';

final userContentsProvider = StreamProvider<List<ContentModel>>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return authAsync.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }

      return FirebaseFirestore.instance
          .collection('contents')
          .where('creatorsIds', arrayContains: user.uid)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ContentModel.fromJson(doc.data()))
                .toList();
          });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
