class SectionsModel {
  final String? id;
  final String? text;
  final int? order;
  SectionsModel({this.text, this.order, this.id});

  factory SectionsModel.fromJson(Map<String, dynamic> map) {
    return SectionsModel(
      text: map['text'] ?? '',
      order: map['order'] ?? 0,
      id: map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text,
      if (order != null) 'order': order,
      if (id != null) 'id': id,
    };
  }
}
