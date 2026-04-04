import 'package:cloud_firestore/cloud_firestore.dart';

class UnlockedChaptersModel {
  final String userId;
  final String chapterId;
  final DateTime unlockedAt;
  final DateTime expiresAt;
  UnlockedChaptersModel({
    required this.userId,
    required this.chapterId,
    required this.unlockedAt,
    required this.expiresAt,
  });

  factory UnlockedChaptersModel.fromJson(Map<String, dynamic> map) {
    return UnlockedChaptersModel(
      userId: map['userId'],
      chapterId: map['chapterId'],
      unlockedAt: (map['unlockedAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'chapterId': chapterId,
      'unlockedAt': unlockedAt,
      'expiresAt': expiresAt,
    };
  }
}
