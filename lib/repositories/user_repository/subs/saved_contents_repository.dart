import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/user_model/subs/saved_contents.dart';

class SavedContentsRepository {
  final String id;
  SavedContentsRepository({required this.id});

  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .collection('saved_contents');

  Future<void> create(SavedContentsModel chapter, String id) async {
    await _collection.doc(id).set(chapter.toJson());
  }

  Future<SavedContentsModel?> get(String contentId) async {
    final doc = await _collection.doc(contentId).get();
    if (doc.exists) {
      return SavedContentsModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> delete(String contentId) async {
    await _collection.doc(contentId).delete();
  }
}
