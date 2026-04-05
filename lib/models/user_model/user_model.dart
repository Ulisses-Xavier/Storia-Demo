import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final double? totalEarnings;
  final DateTime? creationDate;
  UserModel({
    this.name,
    this.id,
    this.email,
    this.totalEarnings,
    this.image,
    this.creationDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      image: map['image'],
      totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
      creationDate:
          map['creationDate'] != null
              ? (map['creationDate'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (image != null) 'image': image,

      if (totalEarnings != null) 'totalEarnings': totalEarnings,
      if (creationDate != null)
        'creationDate': Timestamp.fromDate(creationDate!),
    };
  }
}
