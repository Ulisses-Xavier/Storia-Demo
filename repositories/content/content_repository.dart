import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content/content_model.dart';

class ContentRepository {
  final Map<String, List<ContentModel>> _allCache = {};
  final Map<String, ContentModel> _cache = {};
  final _collection = FirebaseFirestore.instance.collection('contents');

  //Cria um documento de Content
  Future<void> create(ContentModel content, String id) async {
    await _collection.doc(id).set(content.toJson());
  }

  //Consulta um documento de Content via ID
  Future<ContentModel?> get(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return ContentModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Pegar todo e qualquer CONTENT (com cache)
  Future<List<ContentModel>> getAll({bool rank = false}) async {
    final cacheKey = 'getAll_rank_$rank';

    // Retorna do cache se existir
    if (_allCache.containsKey(cacheKey)) {
      return _allCache[cacheKey]!;
    }

    Query query = _collection;

    if (rank) {
      query = query.orderBy('views', descending: true);
    }

    final docs = await query.get();

    if (docs.docs.isEmpty) {
      _allCache[cacheKey] = [];
      return [];
    }

    final result =
        docs.docs
            .map(
              (doc) =>
                  ContentModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

    // Salva no cache
    _allCache[cacheKey] = result;

    return result;
  }

  // Pega todo CONTENT de uma categoria (com cache em memória)
  Future<List<ContentModel>> getByTag(String tagId, {bool rank = false}) async {
    //chave única pro cache
    final String cacheKey = 'tag:$tagId|rank:$rank';

    //retorna do cache se existir
    if (_allCache.containsKey(cacheKey)) {
      return _allCache[cacheKey]!;
    }

    Query query = _collection.where('mainTag.id', isEqualTo: tagId);

    if (rank) {
      query = query.orderBy('views', descending: true);
    }

    final docs = await query.get();

    final result =
        docs.docs
            .map(
              (doc) =>
                  ContentModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

    _allCache[cacheKey] = result;

    return result;
  }

  //Pega todo CONTENT via userID
  Future<List<ContentModel>?> getByUser(String userId) async {
    final querySnapshot =
        await _collection.where('creatorsIds', arrayContains: userId).get();

    final contents =
        querySnapshot.docs
            .map((doc) => ContentModel.fromJson(doc.data()))
            .toList();
    if (contents.isEmpty) {
      return null;
    }
    return contents;
  }

  // Atualiza um documento de Content
  Future<void> update(String id, ContentModel content) async {
    await _collection.doc(id).set(content.toJson(), SetOptions(merge: true));
  }

  // Atualiza lasChapterDatePost
  Future<void> updateLastChapterDate(String id, DateTime date) async {
    await _collection.doc(id).update({
      'lastChapterDatePost': Timestamp.fromDate(date),
    });
  }

  // Apaga um documento de Content
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  // Adiciona uma nova url na lista de capas de capítulos
  Future<void> addChapterCover(String contentId, String url) {
    return _collection.doc(contentId).update({
      'chaptersCovers': FieldValue.arrayUnion([url]),
    });
  }

  // Remove uma nova url na lista de capas de capítulos
  Future<void> removeChapterCover(String contentId, String url) {
    return _collection.doc(contentId).update({
      'chaptersCovers': FieldValue.arrayRemove([url]),
    });
  }

  //Consulta todos os ids de uma lista
  Future<List<ContentModel>> getByList(List<String> ids) async {
    if (ids.isEmpty) return [];

    List<ContentModel> data = [];
    List<String> idsToFetch = [];

    for (var id in ids) {
      final cached = _cache[id];
      if (cached != null) {
        data.add(cached);
      } else {
        idsToFetch.add(id);
      }
    }

    if (idsToFetch.isNotEmpty) {
      List<List<String>> chunks = [];

      for (var i = 0; i < idsToFetch.length; i += 10) {
        chunks.add(
          idsToFetch.sublist(
            i,
            i + 10 > idsToFetch.length ? idsToFetch.length : i + 10,
          ),
        );
      }

      final futures = chunks.map((chunk) {
        return _collection.where(FieldPath.documentId, whereIn: chunk).get();
      });

      final snapshots = await Future.wait(futures);

      for (var snapshot in snapshots) {
        for (var doc in snapshot.docs) {
          final content = ContentModel.fromJson(doc.data());
          data.add(content);
          _cache[content.id!] = content; // salva direto
        }
      }
    }

    // Mantém a ordem original
    data.sort((a, b) => ids.indexOf(a.id!).compareTo(ids.indexOf(b.id!)));

    return data;
  }
}
