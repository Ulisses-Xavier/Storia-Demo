class SearchModel {
  final String? contentId;
  final String? title;
  final String? mainTag;
  final String? coverUrl;
  final int? searchCount;
  SearchModel({
    this.contentId,
    this.title,
    this.coverUrl,
    this.searchCount,
    this.mainTag,
  });

  factory SearchModel.fromJson(Map<String, dynamic> map, String id) {
    return SearchModel(
      title: map['title'] ?? '',
      contentId: id,
      coverUrl: map['coverUrl'],
      searchCount: map['searchCount'],
      mainTag: map['mainTag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (contentId != null) 'contentId': contentId,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (searchCount != null) 'searchCount': searchCount,
      if (mainTag != null) 'mainTag': mainTag,
    };
  }
}
