class TagsModel {
  final String? title;
  final String? id;
  TagsModel({this.title, this.id});

  factory TagsModel.fromJson(Map<String, dynamic> map) {
    return TagsModel(title: map['title'] ?? '', id: map['id']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'id': id};
  }
}
