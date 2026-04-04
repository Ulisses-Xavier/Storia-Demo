import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/search_model.dart';

class SearchRepository {
  final _collection = FirebaseFirestore.instance.collection('searchs');

  Future<void> create(SearchModel model, String id) async {
    await _collection.doc(id).set(model.toJson());
  }

  Future<void> increment(String id) async {
    final docRef = _collection.doc(id);
    await docRef.update({"searchCount": FieldValue.increment(1)});
  }

  Future<void> update(String id, SearchModel chap) async {
    await _collection.doc(id).update(chap.toJson());
  }

  Future<List<SearchModel>> getMostSearched() async {
    final query =
        await _collection
            .orderBy('searchCount', descending: true)
            .limit(10)
            .get();
    if (query.docs.isEmpty) {
      return [];
    }
    return query.docs
        .map((doc) => SearchModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<bool> exists(String id) async {
    final doc = await _collection.doc(id).get();

    if (doc.exists) {
      return true;
    }
    return false;
  }
}
