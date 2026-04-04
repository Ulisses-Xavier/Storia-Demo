class ImagesModel {
  final String url;
  final int order;
  ImagesModel({required this.url, required this.order});

  factory ImagesModel.fromJson(Map<String, dynamic> map) {
    return ImagesModel(url: map['contentId'] ?? '', order: map['order'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'order': order};
  }
}
