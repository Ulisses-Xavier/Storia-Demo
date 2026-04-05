import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content/chapter/chapter_model.dart';

class ChapterRepository {
  final String contentId;
  ChapterRepository({required this.contentId});
  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('contents')
      .doc(contentId)
      .collection('chapters');

  //Cria um documento de Chapters
  Future<void> create(ChapterModel chap, String id) async {
    await _collection.doc(id).set(chap.toJson());
  }

  // Consulta um documento de Chapters
  Future<ChapterModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return ChapterModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Consulta um documento de chapters baseado na order
  Future<ChapterModel?> getByOrder(int order) async {
    try {
      final query =
          await _collection.where('order', isEqualTo: order).limit(1).get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      return ChapterModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  //Consulta capítulos baseado no status
  Future<List<ChapterModel>?> getChapterByStatus(
    String status,
    bool twoStatus,
    String secondStatus, {
    bool? descending,
  }) async {
    final querySnapshot =
        (twoStatus)
            ? await _collection
                .where('status', whereIn: [status, secondStatus])
                .get()
            : descending != null
            ? (await _collection
                .where('status', isEqualTo: status)
                .orderBy('order', descending: descending)
                .get())
            : await _collection.where('status', isEqualTo: status).get();

    final chapters =
        querySnapshot.docs
            .map(
              (doc) =>
                  ChapterModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
    if (chapters.isEmpty) {
      return null;
    }
    return chapters;
  }

  // Atualiza um documento de Chapters
  Future<void> update(String id, ChapterModel chap) async {
    await _collection.doc(id).set(chap.toJson(), SetOptions(merge: true));
  }

  // Apaga um documento de Chapters
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
