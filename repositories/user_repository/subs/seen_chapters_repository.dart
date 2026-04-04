import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/user_model/subs/seen_chapters.dart';

class SeenChaptersRepository {
  final String userId;
  SeenChaptersRepository({required this.userId});
  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('seen_chapters');

  Future<void> create(SeenChaptersModel chapter, String id) async {
    await _collection.doc(id).set(chapter.toJson());
  }

  Future<SeenChaptersModel?> get(String contentId) async {
    final doc = await _collection.doc(contentId).get();
    if (doc.exists) {
      return SeenChaptersModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
