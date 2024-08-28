class refreeNote {
  final String refreeFullName;
  final String refreeId;
  final String note;

  refreeNote({
    required this.refreeFullName,
    required this.refreeId,
    required this.note,
  });

  factory refreeNote.fromJson(Map<String, dynamic> json) {
    return refreeNote(
      refreeFullName: json['refreeFullName'],
      refreeId: json['refreeId'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refreeFullName': refreeFullName,
      'refreeId': refreeId,
      'note': note,
    };
  }
}