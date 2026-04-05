class NamesModel {
  final String? uid;
  NamesModel({required this.uid});

  factory NamesModel.fromJson(Map<String, dynamic> map) {
    return NamesModel(uid: map['uid'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {if (uid != null) 'title': uid};
  }
}
