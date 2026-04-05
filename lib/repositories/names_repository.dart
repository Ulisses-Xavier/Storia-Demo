import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/names_model.dart';

class NamesRepository {
  final _collection = FirebaseFirestore.instance.collection('names');

  Future<void> create(NamesModel model, String name) async {
    await _collection.doc(name).set(model.toJson());
  }

  Future<bool> exists(String name) async {
    final doc = await _collection.doc(name).get();

    if (doc.exists) {
      return true;
    }
    return false;
  }
}
