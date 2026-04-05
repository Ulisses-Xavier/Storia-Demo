class ContentListModel {
  final String title;
  final List<String> contents;
  ContentListModel({required this.title, required this.contents});

  factory ContentListModel.fromJson(Map<String, dynamic> map) {
    return ContentListModel(
      title: map['title'] ?? '',
      contents: List<String>.from(map['contents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'contents': contents};
  }
}
