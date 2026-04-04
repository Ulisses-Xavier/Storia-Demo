class BannersModel {
  final String? id;
  final String? imageUrl;
  final String? title;
  final String? description;
  final Map<String, int>? gradientColor;
  final List<Map<String, dynamic>>? tags;
  final String? route;
  final String? createdBy;
  final int? order;
  BannersModel({
    this.imageUrl,
    this.title,
    this.description,
    this.id,
    this.gradientColor,
    this.tags,
    this.order,
    this.createdBy,
    this.route,
  });

  factory BannersModel.fromJson(Map<String, dynamic> map) {
    return BannersModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      title: map['title'],
      description: map['description'],
      gradientColor:
          map['gradientColor'] != null
              ? Map<String, int>.from(map['gradientColor'])
              : {},
      tags:
          map['tags'] != null
              ? List<Map<String, dynamic>>.from(map['tags'])
              : [],
      route: map['route'],
      createdBy: map['createdBy'],
      order: map['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (gradientColor != null) 'gradientColor': gradientColor,
      if (tags != null) 'tags': tags,
      if (route != null) 'route': route,
      if (createdBy != null) 'createdBy': createdBy,
      if (order != null) 'order': order,
    };
  }
}
