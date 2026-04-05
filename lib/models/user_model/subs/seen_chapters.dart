class SeenChaptersModel {
  final String? contentId;
  final List<String>? chaptersIds;
  SeenChaptersModel({this.contentId, this.chaptersIds});

  factory SeenChaptersModel.fromJson(Map<String, dynamic> map) {
    return SeenChaptersModel(
      contentId: map['contentId'],
      chaptersIds: List<String>.from(map['chaptersIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (contentId != null) 'userId': contentId,
      if (chaptersIds != null) 'chaptersIds': chaptersIds,
    };
  }
}
