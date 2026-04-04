import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/user_model/user_model.dart';

class UserRepository {
  final Map<String, dynamic> _cacheUser = {};
  final _collection = FirebaseFirestore.instance.collection('users');

  //Cria um documento de Users
  Future<void> create(UserModel user, String id) async {
    await _collection.doc(id).set(user.toJson());
  }

  //Consulta um documento de Users
  Future<UserModel?> get(String id) async {
    final cacheKey = 'get_$id';

    // Retorna do cache se existir
    if (_cacheUser.containsKey(cacheKey)) {
      return _cacheUser[cacheKey]!;
    }

    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      final model = UserModel.fromJson(doc.data()!);
      _cacheUser.addAll({cacheKey: model});
      return model;
    }
    _cacheUser.remove(cacheKey);
    return null;
  }

  Future<void> update(String id, UserModel user) async {
    await _collection.doc(id).set(user.toJson(), SetOptions(merge: true));
  }

  //Apaga um documento de Users
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
