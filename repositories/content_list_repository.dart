import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content_list_model.dart';

class ContentListRepository {
  final _collection = FirebaseFirestore.instance.collection('content_list');

  //Cria um documento de Content List
  Future<void> create(ContentListModel contentList) async {
    await _collection.add(contentList.toJson());
  }

  // Consulta um documento de Content List
  Future<ContentListModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return ContentListModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Atualiza um documento de Content List
  Future<void> update(String id, ContentListModel chap) async {
    await _collection.doc(id).update(chap.toJson());
  }

  // Apaga um documento de Content List
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
