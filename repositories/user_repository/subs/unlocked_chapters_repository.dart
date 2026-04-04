import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/user_model/subs/unlocked_chapters.dart';

class ChapterUnlockRepository {
  final String userId;
  ChapterUnlockRepository({required this.userId});
  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('unlocked_chapters');

  //Cria um documento de ChapterUnlock
  Future<void> create(UnlockedChaptersModel chapUn) async {
    await _collection.add(chapUn.toJson());
  }

  // Consulta um documento de ChapterUnlock
  Future<UnlockedChaptersModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return UnlockedChaptersModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Atualiza um documento de ChapterUnlock
  Future<void> update(String id, UnlockedChaptersModel chapUn) async {
    await _collection.doc(id).update(chapUn.toJson());
  }

  // Apaga um documento de ChapterUnlock
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
