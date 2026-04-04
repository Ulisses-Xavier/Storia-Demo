import 'package:cloud_firestore/cloud_firestore.dart';

class ContentModel {
  final String? id;
  final String? format;
  final String? title;
  final String? titleSearch;
  final String? description;
  final String? cover;
  final String? coverLong;
  final String? coverMini;
  final List<String?>? chaptersCovers;
  final List<Map<String, dynamic>>? tags;
  final Map<String, dynamic>? mainTag;
  final List<String>? creatorsIds;
  final DateTime? creationDate;
  final Map<String, int>? rgbColor;
  final int? followersCount;
  final bool? completed;
  final String? fontFamily;
  final bool? adsUnblocked;
  final DateTime? lastChapterDatePost;
  final int? views;
  final int? likes;
  final int? score;
  final double? totalEarning;
  ContentModel({
    this.id,
    this.completed,
    this.adsUnblocked,
    this.likes,
    this.titleSearch,
    this.score,
    this.views,
    this.coverMini,
    this.lastChapterDatePost,
    this.fontFamily,
    this.totalEarning,
    this.coverLong,
    this.followersCount,
    this.rgbColor,
    this.format,
    this.chaptersCovers,
    this.title,
    this.description,
    this.mainTag,
    this.cover,
    this.tags,
    this.creatorsIds,
    this.creationDate,
  });

  factory ContentModel.fromJson(Map<String, dynamic> map) {
    return ContentModel(
      id: map['id'],
      format: map['format'],
      title: map['title'],
      titleSearch: map['titleSearch'],
      description: map['description'],
      cover: map['cover'],
      coverLong: map['coverLong'],
      fontFamily: map['fontFamily'],
      coverMini: map['coverMini'],
      likes: map['likes'],
      score: map['score'],
      views: map['views'],
      tags:
          map['tags'] != null
              ? List<Map<String, dynamic>>.from(map['tags'])
              : [],
      mainTag: map['mainTag'],
      followersCount: map['followersCount'],
      lastChapterDatePost:
          map['lastChapterDatePost'] != null
              ? (map['lastChapterDatePost'] as Timestamp).toDate()
              : null,
      chaptersCovers:
          map['chaptersCovers'] != null
              ? List<String>.from(map['chaptersCovers'])
              : [],
      rgbColor:
          map['rgbColor'] != null ? Map<String, int>.from(map['rgbColor']) : {},
      creatorsIds:
          map['creatorsIds'] != null
              ? List<String>.from(map['creatorsIds'])
              : [],
      creationDate:
          map['creationDate'] != null
              ? (map['creationDate'] as Timestamp).toDate()
              : null,
      completed: map['completed'] ?? false,
      adsUnblocked: map['adsUnblocked'] ?? 0,
      totalEarning: map['totalEarning'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (format != null) 'format': format,
      if (title != null) 'title': title,
      if (titleSearch != null) 'titleSearch': titleSearch,
      if (description != null) 'description': description,
      if (cover != null) 'cover': cover,
      if (lastChapterDatePost != null)
        'lastChapterDatePost': Timestamp.fromDate(lastChapterDatePost!),
      if (rgbColor != null) 'rgbColor': rgbColor,
      if (coverMini != null) 'coverMini': coverMini,
      if (fontFamily != null) 'fontFamily': fontFamily,
      if (coverLong != null) 'coverLong': coverLong,
      if (tags != null) 'tags': tags,
      if (creatorsIds != null) 'creatorsIds': creatorsIds,
      if (followersCount != null) 'followersCount': followersCount,
      if (views != null) 'views': views,
      if (score != null) 'score': score,
      if (likes != null) 'likes': likes,
      if (creationDate != null)
        'creationDate': Timestamp.fromDate(creationDate!),
      if (chaptersCovers != null) 'chaptersCovers': chaptersCovers,
      if (completed != null) 'completed': completed,
      if (adsUnblocked != null) 'adsUnblocked': adsUnblocked,
      if (totalEarning != null) 'totalEarning': totalEarning,
      if (mainTag != null) 'mainTag': mainTag,
    };
  }
}
