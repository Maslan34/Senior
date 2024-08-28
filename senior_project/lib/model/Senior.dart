class Senior {
  final String contactStudentId;
  final String seniorName;
  final String seniorPdf;
  final String seniorVideo;
  final List<String> members;
  final String? teamMember;
  final String department;
  final String master;
  final List<dynamic> grade;
  final String? member;
  final bool isMasterGraded;
  DateTime createdAt;
  double  finalGrade;
  final List<dynamic> comment;

  Senior({
    required this.contactStudentId,
    required this.seniorName,
    required this.seniorPdf,
    required this.seniorVideo,
    required this.members,
    this.teamMember,
    required this.department,
    required this.master,
    required this.grade,
    required this.createdAt,
    this.member,
    required this.isMasterGraded,
    required this.finalGrade,
    required this.comment,
  }) ; // masterGrade null ise 0 atandı


  factory Senior.fromJson(Map<String, dynamic> json) {
    return Senior(
      contactStudentId: json['contactStudentId'],
      seniorName: json['seniorName'],
      seniorPdf: json['seniorPdf'],
      seniorVideo: json['seniorVideo'],
      members: List<String>.from(json['members']),
      department: json['department'],
      master: json['master'],
      grade: List<dynamic>.from(json['grade']  ), // grade alanı güncellendi
      createdAt: DateTime.parse(json['createdAt']),
      member: json['member'],
      isMasterGraded: json['isMasterGraded'] ?? false,
      finalGrade: (json['final'] ?? -1).toDouble(),
      comment: json['comment'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactStudentId': contactStudentId,
      'seniorName': seniorName,
      'seniorPdf': seniorPdf,
      'seniorVideo': seniorVideo,
      'members': members,
      'department': department,
      'master': master,
      'grade': grade,
      'createdAt': createdAt.toIso8601String(),
      'member': member,
      'isMasterGraded': isMasterGraded,
      'final':finalGrade
    };
  }
}
