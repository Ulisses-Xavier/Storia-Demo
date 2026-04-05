import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/tags_model.dart';

class TagsRepository {
  final _collection = FirebaseFirestore.instance.collection('tags');

  //Cria um documento de Users
  Future<void> create(TagsModel tags) async {
    await _collection.add(tags.toJson());
  }

  //Consulta um documento de tags
  Future<TagsModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return TagsModel.fromJson(doc.data()!);
    }
    return null;
  }

  //Consulta todos os documentos de tags
  Future<List<TagsModel>> getAll() async {
    final querySnapshot = await _collection.get(); // pega todos os documentos

    return querySnapshot.docs.map((doc) {
      return TagsModel.fromJson(doc.data());
    }).toList();
  }

  //Atualiza um documento de Users
  Future<void> update(String id, TagsModel tags) async {
    await _collection.doc(id).update(tags.toJson());
  }

  //Apaga um documento de Users
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
