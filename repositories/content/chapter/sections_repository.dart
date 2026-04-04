import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content/chapter/sections_model.dart';

class SectionsRepository {
  final String contentId;
  final String chapterId;
  SectionsRepository({required this.contentId, required this.chapterId});
  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('contents')
      .doc(contentId)
      .collection('chapters')
      .doc(chapterId)
      .collection('sections');

  //Cria um documento de sections
  Future<void> create(SectionsModel sections, String id) async {
    await _collection.doc(id).set(sections.toJson());
  }

  // Consulta documentos de sections
  Future<List<SectionsModel>?> getAll() async {
    final querySnapshot = await _collection.orderBy('order').get();
    final sections =
        querySnapshot.docs.map((doc) {
          return SectionsModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
    if (sections.isEmpty) {
      return null;
    }
    return sections;
  }

  // Atualiza um documento de sections
  Future<void> update(String id, SectionsModel sections) async {
    await _collection.doc(id).set(sections.toJson(), SetOptions(merge: true));
  }

  // Apaga um documento de sections
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
