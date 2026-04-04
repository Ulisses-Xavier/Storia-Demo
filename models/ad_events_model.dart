import 'package:cloud_firestore/cloud_firestore.dart';

class AdEventsModel {
  final String chapterId;
  final String userId;
  final String contentId;
  final String adType; //("rewarded" / "interstitial")
  final DateTime viewDate;
  final double earning;
  AdEventsModel({
    required this.chapterId,
    required this.userId,
    required this.adType,
    required this.contentId,
    required this.viewDate,
    required this.earning,
  });

  factory AdEventsModel.fromJson(Map<String, dynamic> map) {
    return AdEventsModel(
      chapterId: map['chapterId'] ?? '',
      userId: map['userId'] ?? '',
      contentId: map['contentId'] ?? '',
      adType: map['adType'] ?? '',
      viewDate: (map['viewDate'] as Timestamp).toDate(),
      earning: (map['earnings'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'userId': userId,
      'contentId': contentId,
      'adType': adType,
      'viewDate': Timestamp.fromDate(viewDate),
      'earning': earning,
    };
  }
}
