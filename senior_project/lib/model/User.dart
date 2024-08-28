
import 'Master.dart';
import 'Student.dart';

class userModel {
  final String userUniqueID;
  String username;
  String affiliation;
  String email;
  final String givenName;
  final String familyName;
  int role;
  String department;
  final DateTime createdAt;
  DateTime updatedAt;
  final int version;
  bool? getNotifications;

  userModel({
    required this.userUniqueID,
    required this.username,
    required this.affiliation,
    required this.email,
    required this.givenName,
    required this.familyName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.getNotifications,
    required this.department,

  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    switch (json['role']) {
      case 2:
        return Student.fromJson(json);
      case 3:
        return Master.fromJson(json);
      default:
        return userModel(
          userUniqueID: json['userUniqueID'],
          username: json['username'],
          affiliation: json['affiliation'],
          email: json['email'],
          givenName: json['givenName'],
          familyName: json['familyName'],
          role: json['role'],
          department: json['department'],
          createdAt: DateTime.parse(json['createdAt']),
          updatedAt: DateTime.parse(json['updatedAt']),
          version: json['__v'],
          getNotifications: json['getNotifications'],
        );
    }
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
    };
  }




}

