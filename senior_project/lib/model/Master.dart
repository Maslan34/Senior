import 'User.dart';

class Master extends userModel {

  Master({

    required String userUniqueID,
    required String username,
    required String affiliation,
    required String email,
    required String givenName,
    required String familyName,
    required int role,
    required String active,
    required List<String> topics,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
    required bool? getNotifications,
    required bool? beJury,
    required bool? isSubmitted,
    required String department,
  }) : super(
      userUniqueID: userUniqueID,
      username: username,
      affiliation: affiliation,
      email: email,
      givenName: givenName,
      familyName: familyName,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      getNotifications: getNotifications,
      department: department
  );

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(

      userUniqueID: json['userUniqueID'],
      username: json['username'],
      affiliation: json['affiliation'],
      email: json['email'],
      givenName: json['givenName'],
      familyName: json['familyName'],
      role: json['role'],
      active: json['active'],
      topics: List<String>.from(json['topics']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
      getNotifications: json['getNotifications'],
      beJury: json['beJury'],
      isSubmitted: json['isSubmitted'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userUniqueID': userUniqueID,
      'username': username,
      'affiliation': affiliation,
      'email': email,
      'givenName': givenName,
      'familyName': familyName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'getNotifications': getNotifications,
      'department': department
    };
  }

}