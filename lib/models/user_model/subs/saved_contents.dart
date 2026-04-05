import 'package:cloud_firestore/cloud_firestore.dart';

class SavedContentsModel {
  final String? contentId;
  final String? title;
  final DateTime? savedAt;
  SavedContentsModel({this.contentId, this.savedAt, this.title});

  factory SavedContentsModel.fromJson(Map<String, dynamic> map) {
    return SavedContentsModel(
      contentId: map['contentId'],
      title: map['title'],
      savedAt:
          map['savedAt'] != null
              ? (map['savedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (contentId != null) 'contentId': contentId,
      if (savedAt != null) 'savedAt': Timestamp.fromDate(savedAt!),
    };
  }
}
