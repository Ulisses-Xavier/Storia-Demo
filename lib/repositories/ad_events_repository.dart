import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/ad_events_model.dart';

class AdEventsRepository {
  final _collection = FirebaseFirestore.instance.collection('ad_events');

  //Cria um documento de Ad Tracking
  Future<void> create(AdEventsModel adtrack) async {
    await _collection.add(adtrack.toJson());
  }

  // Consulta um documento de Ad Tracking
  Future<AdEventsModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return AdEventsModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Atualiza um documento de AdTracking
  Future<void> update(String id, AdEventsModel adtrack) async {
    await _collection.doc(id).update(adtrack.toJson());
  }

  // Apaga um documento de Chapters
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
