import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/models/tags_model.dart';

final tagProvider = StreamProvider<List<TagsModel>?>((ref) {
  return FirebaseFirestore.instance.collection('tags').snapshots().map((doc) {
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((doc) => TagsModel.fromJson(doc.data())).toList();
    } else {
      return null;
    }
  });
});
