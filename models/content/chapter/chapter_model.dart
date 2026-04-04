import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterModel {
  final String? id;
  final String? contentId;
  final String? title;
  final String? rawText;
  final String? cover;
  final String? status; // draft, scheduled, published
  final DateTime? publishAt;
  final DateTime? createdAt;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final int? views;
  final int? adViews;
  final Map<String, dynamic>?
  isLocked; //bool, type: ("rewarded" / "interstitial")
  final double? chapterEarning;
  final int? order;

  ChapterModel({
    this.id,
    this.contentId,
    this.title,
    this.cover,
    this.status,
    this.rawText,
    this.publishAt,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.views,
    this.adViews,
    this.isLocked,
    this.chapterEarning,
    this.order,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'],
      contentId: map['contentId'],
      title: map['title'],
      cover: map['cover'],
      status: map['status'] ?? 'draft',
      rawText: map['rawText'],
      publishAt:
          map['publishAt'] != null
              ? (map['publishAt'] as Timestamp).toDate()
              : null,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : null,
      updatedAt:
          map['updatedAt'] != null
              ? (map['updateAt'] as Timestamp).toDate()
              : null,
      publishedAt:
          map['publishedAt'] != null
              ? (map['publishedAt'] as Timestamp).toDate()
              : null,
      views: map['views'] ?? 0,
      adViews: map['adViews'] ?? 0,
      isLocked: map['isLocked'],
      chapterEarning: map['chapterEarning'] ?? 0.0,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (contentId != null) 'contentId': contentId,
      if (title != null) 'title': title,
      if (cover != null) 'cover': cover,
      if (status != null) 'status': status,
      if (publishAt != null) 'publishAt': Timestamp.fromDate(publishAt!),
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (publishedAt != null) 'publishedAt': Timestamp.fromDate(publishedAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (views != null) 'views': views,
      if (adViews != null) 'adViews': adViews,
      if (isLocked != null) 'isLocked': isLocked,
      if (chapterEarning != null) 'chapterEarning': chapterEarning,
      if (order != null) 'order': order,
      if (rawText != null) 'rawText': rawText,
    };
  }
}
