import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/banners_model.dart';

class BannersRepository {
  final _collection = FirebaseFirestore.instance.collection('banners');

  Future<void> create(BannersModel banners) async {
    await _collection.add(banners.toJson());
  }

  Future<BannersModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return BannersModel.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<BannersModel>> watchAll() {
    return _collection.orderBy('order').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BannersModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<List<BannersModel>?> getAll() async {
    final docs = await _collection.get();
    final banners =
        docs.docs
            .map((banner) => BannersModel.fromJson(banner.data()))
            .toList();
    if (banners.isNotEmpty) {
      return banners;
    }

    return null;
  }

  Future<void> update(String id, BannersModel banners) async {
    await _collection.doc(id).update(banners.toJson());
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
