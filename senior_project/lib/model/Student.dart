import 'User.dart';

class Student extends userModel {
  bool isSubmitted;
  String seniorName;
  String? teamMember;
  String studentNumber;
  String master;

  Student({

    // userModel'in parametreleri
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
    required this.isSubmitted,
    required this.seniorName,
    required this.studentNumber,
    this.teamMember,
    required String department,
    required this.master,
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

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userUniqueID: json['userUniqueID'],
      username: json['username'],
      affiliation: json['affiliation'],
      email: json['email'],
      givenName: json['givenName'],
      familyName: json['familyName'],
      role: json['role'],
      seniorName: json['seniorName'],
      teamMember: json['teamMember'],
      studentNumber: json['studentNumber'],
      active: json['active'],
      topics: List<String>.from(json['topics']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
      getNotifications: json['getNotifications'],
      beJury: json['beJury'],
      isSubmitted: json['isSubmitted'],
      department: json['department'],
      master: json['master']
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
      'isSubmitted': isSubmitted,
      '__v': version,
      'getNotifications': getNotifications,
      'department': department,
      'teamMember':teamMember,
      'seniorName':seniorName,
      'studentNumber':studentNumber,
      'master':master,
    };
  }
}