import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storia/models/content/content_model.dart';

class FeedContentRepository {
  final _collection = FirebaseFirestore.instance.collection('contents');

  //RETORNA-TODO-CONTENT-EM-ORDEM-DE-CRIAÇÃO
  Map<String, dynamic> getRecentsCache = {};

  Future<Map<String, dynamic>> getRecents({
    bool limitToSix = false,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    // CACHE KEY
    final String cacheKey =
        '${limitToSix.toString()}|${lastDoc?.id ?? "first"}';

    if (getRecentsCache.containsKey(cacheKey)) {
      return getRecentsCache[cacheKey];
    }

    // QUERY BASE
    Query<Map<String, dynamic>> snapshot = _collection.orderBy(
      'creationDate',
      descending: true,
    );

    // LIMIT + PAGINATION
    if (limitToSix) {
      snapshot = snapshot.limit(6);
    } else {
      if (lastDoc != null) {
        snapshot = snapshot.startAfterDocument(lastDoc);
      }
      snapshot = snapshot.limit(20);
    }

    // EXECUTE
    final query = await snapshot.get();

    // EMPTY SAFE RETURN
    if (query.docs.isEmpty) {
      final emptyReturn = {'data': <ContentModel>[], 'lastDoc': null};

      getRecentsCache[cacheKey] = emptyReturn;
      return emptyReturn;
    }

    // PROCESS DATA
    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final result = {'data': data, 'lastDoc': newLastDoc};

    // CACHE SAVE
    getRecentsCache[cacheKey] = result;

    return result;
  }

  //RETORNA-TODO-CONTENT-EM-ORDEM-DE-SCORE
  Map<String, dynamic> getPopularsCache = {};
  Future<Map<String, dynamic>> getPopulars({
    bool limitToSix = false,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    // CACHE KEY
    final String cacheKey =
        '${limitToSix.toString()}|${lastDoc?.id ?? "first"}';

    if (getPopularsCache.containsKey(cacheKey)) {
      return getPopularsCache[cacheKey];
    }

    // QUERY BASE
    Query<Map<String, dynamic>> snapshot = _collection.orderBy(
      'score',
      descending: true,
    );

    // LIMIT VARIATION
    if (limitToSix) {
      snapshot = snapshot.limit(6);
    } else {
      if (lastDoc != null) {
        snapshot = snapshot.startAfterDocument(lastDoc);
      }
      snapshot = snapshot.limit(20);
    }

    // EXECUTE
    final query = await snapshot.get();

    // EMPTY SAFE RETURN (NUNCA {} vazio)
    if (query.docs.isEmpty) {
      final emptyReturn = {'data': <ContentModel>[], 'lastDoc': null};

      getPopularsCache[cacheKey] = emptyReturn;
      return emptyReturn;
    }

    // PROCESS DATA
    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final result = {'data': data, 'lastDoc': newLastDoc};

    // CACHE SAVE
    getPopularsCache[cacheKey] = result;

    return result;
  }

  //RETORNA-TODO-CONTENT
  Map<String, dynamic> getCache = {};
  Future<Map<String, dynamic>> get({
    bool rank = true,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    //CACHE CHECK
    final String cacheKey = '${rank.toString()}|${lastDoc?.id ?? "first"}';

    if (getCache.containsKey(cacheKey)) {
      return getCache[cacheKey];
    }

    //ACTUAL QUERY
    Query<Map<String, dynamic>> snapshot;

    if (lastDoc != null) {
      snapshot = _collection
          .orderBy('score', descending: rank)
          .startAfterDocument(lastDoc)
          .limit(20);
    } else {
      snapshot = _collection.orderBy('score', descending: rank).limit(20);
    }

    final query = await snapshot.get();

    if (query.docs.isEmpty) {
      getCache.addAll({cacheKey: {}});
      return {};
    }

    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final theReturn = {'data': data, 'lastDoc': newLastDoc};
    getCache.addAll({cacheKey: theReturn});
    return theReturn;
  }

  //RETORNA-TODO-CONTENT-BASEADO-NA-MAINTAG-AND-FILTERS
  Map<String, dynamic> getByTagCache = {};
  Future<Map<String, dynamic>> getByTag(
    String id, {
    DocumentSnapshot<Object?>? lastDoc,
    String sortBy = 'popular',
  }) async {
    //CACHE CHECK
    final String cacheKey = '$id|$sortBy|${lastDoc?.id ?? "first"}';

    if (getByTagCache.containsKey(cacheKey)) {
      return getByTagCache[cacheKey];
    }

    //ACTUAL QUERY
    Query<Map<String, dynamic>> snapshot;

    late String sort;

    switch (sortBy) {
      case 'popular':
        sort = 'score';
        break;

      case 'newChap':
        sort = 'lastChapterDatePost';
        break;

      default:
        sort = 'creationDate';
    }

    if (lastDoc != null) {
      snapshot = _collection
          .where('mainTag.id', isEqualTo: id)
          .orderBy(sort, descending: true)
          .startAfterDocument(lastDoc)
          .limit(20);
    } else {
      snapshot = _collection
          .where('mainTag.id', isEqualTo: id)
          .orderBy(sort, descending: true)
          .limit(20);
    }

    final query = await snapshot.get();

    if (query.docs.isEmpty) {
      getByTagCache.addAll({cacheKey: {}});
      return {};
    }

    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final theReturn = {'data': data, 'lastDoc': newLastDoc};
    getByTagCache.addAll({cacheKey: theReturn});
    return theReturn;
  }

  //TROCAR ESSE FUNÇÃO NO DASHBAORD DEPOIS | PARA A COM LASTDOC
  Map<String, List<ContentModel>> getBySearchCache = {};
  Future<List<ContentModel>> getBySearch({
    bool rank = true,
    String? term,
  }) async {
    if (term == null) return [];

    //CACHE CHECK
    final String cacheKey = '$term|${rank.toString()}}';

    if (getBySearchCache.containsKey(cacheKey)) {
      return getBySearchCache[cacheKey]!;
    }

    //ACTUAL QUERY
    Query<Map<String, dynamic>> snapshot;

    snapshot = _collection
        .where('titleSearch', isGreaterThanOrEqualTo: term)
        // ignore: prefer_interpolation_to_compose_strings
        .where('titleSearch', isLessThanOrEqualTo: term + '\uf8ff')
        .limit(10);

    final query = await snapshot.get();

    if (query.docs.isEmpty) {
      getBySearchCache.addAll({cacheKey: []});
      return [];
    }

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final theReturn = data;
    getBySearchCache.addAll({cacheKey: data});
    return theReturn;
  }

  //GET BY SEARCH
  Map<String, dynamic> getBySearch2Cache = {};
  Future<Map<String, dynamic>> getBySearch2({
    String? term,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    if (term == null) return {};

    //CACHE CHECK
    final String cacheKey = '$term|${lastDoc?.id ?? 'first'}}';

    if (getBySearch2Cache.containsKey(cacheKey)) {
      return getBySearch2Cache[cacheKey]!;
    }

    //ACTUAL QUERY
    Query<Map<String, dynamic>> snapshot;

    snapshot = _collection
        .where('titleSearch', isGreaterThanOrEqualTo: term)
        // ignore: prefer_interpolation_to_compose_strings
        .where('titleSearch', isLessThanOrEqualTo: term + '\uf8ff');

    if (lastDoc != null) {
      snapshot = snapshot.startAfter([lastDoc.id]);
    }

    snapshot = snapshot.limit(20);

    final query = await snapshot.get();

    if (query.docs.isEmpty) {
      return {};
    }

    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final theReturn = {'data': data, 'lastDoc': newLastDoc};
    getBySearch2Cache[cacheKey] = theReturn;
    return theReturn;
  }

  //GET ALL WITH FILTERS
  Map<String, dynamic> getByFiltersCache = {};
  Future<Map<String, dynamic>> getByFilters({
    List<String>? tagsIds,
    String sortBy = 'popular',
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    // NORMALIZA TAGS (importante pro cache)
    final normalizedTags = [...(tagsIds ?? [])]..sort();

    final String cacheKey = '$normalizedTags|$sortBy|${lastDoc?.id ?? "first"}';

    if (getByFiltersCache.containsKey(cacheKey)) {
      return getByFiltersCache[cacheKey];
    }

    Query<Map<String, dynamic>> snapshot = _collection;

    // FILTER TAGS | LIMIT 10 PER LIST
    if (normalizedTags.isNotEmpty) {
      snapshot = snapshot.where('mainTag.id', whereIn: normalizedTags);
    }

    late String sort;

    // ORDER
    switch (sortBy) {
      case 'popular':
        sort = 'score';
        break;

      case 'newChap':
        sort = 'lastChapterDatePost';
        break;

      default:
        sort = 'creationDate';
    }

    snapshot = snapshot
        .orderBy(sort, descending: true)
        .orderBy(FieldPath.documentId);

    // PAGINATION
    if (lastDoc != null) {
      snapshot = snapshot.startAfter([lastDoc[sort], lastDoc.id]);
    }

    snapshot = snapshot.limit(20);

    final query = await snapshot.get();

    // EMPTY SAFE
    if (query.docs.isEmpty) {
      final emptyReturn = {'data': <ContentModel>[], 'lastDoc': null};

      getByFiltersCache[cacheKey] = emptyReturn;
      return emptyReturn;
    }

    final newLastDoc = query.docs.last;

    final data =
        query.docs.map((doc) => ContentModel.fromJson(doc.data())).toList();

    final result = {'data': data, 'lastDoc': newLastDoc};

    getByFiltersCache[cacheKey] = result;

    return result;
  }
}
