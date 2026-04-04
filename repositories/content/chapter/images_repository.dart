import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content/chapter/images_model.dart';

class ImagesRepository {
  final String contentId;
  final String chapterId;
  ImagesRepository({required this.contentId, required this.chapterId});
  CollectionReference get _collection => FirebaseFirestore.instance
      .collection('contents')
      .doc(contentId)
      .collection('chapters')
      .doc(chapterId)
      .collection('images');

  //Cria um documento de images
  Future<void> create(ImagesModel images) async {
    await _collection.add(images.toJson());
  }

  // Consulta um documento de images
  Future<ImagesModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return ImagesModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Atualiza um documento de images
  Future<void> update(String id, ImagesModel img) async {
    await _collection.doc(id).update(img.toJson());
  }

  // Apaga um documento de images
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
