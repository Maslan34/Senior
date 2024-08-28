
import 'package:senior_project/model/Refree.dart';

class thesisModel{
  final String makaleID;
  final String title;
  final String subject;
  final String author;
  final String authorName;
  final String status;
  final Map<String, dynamic> makaleIcerigi;
  final String pdfThesis;
  final String editorID;
  final String active;
  final List<String> seenAbleEditors;
  final List<Refree> seenAbleRefree;
  final int revisionCount;
  final List<RefreeNote> refreeNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

   bool isShowed=false;

  thesisModel({
    required this.makaleID,
    required this.title,
    required this.subject,
    required this.author,
    required this.authorName,
    required this.status,
    required this.makaleIcerigi,
    required this.pdfThesis,
    required this.editorID,
    required this.active,
    required this.seenAbleEditors,
    required this.seenAbleRefree,
    required this.revisionCount,
    required this.refreeNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory thesisModel.fromJson(Map<String, dynamic> json) {
    return thesisModel(

      makaleID: json['makaleID'],
      title: json['title'],
      subject: json['subject'],
      author: json['author'],
      authorName: json['authorName'],
      status: json['status'],
      makaleIcerigi: json['makaleIcerigi'],
      pdfThesis: json['pdfThesis'],
      editorID: json['editorID'],
      active: json['active'],
      seenAbleEditors: List<String>.from(json['seenAbleEditors']),
      seenAbleRefree: (json['seenAbleRefree'] as List)
          .map((refree) => Refree.fromJson(refree))
          .toList(),
      revisionCount: json['revisionCount'],
      refreeNotes: List<RefreeNote>.from(json['refreeNotes']
          .map((note) => RefreeNote.fromJson(note))),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
    );
  }
}



class RefreeNote {
  final String refreeName;
  final int refreeDecision;
  final String refreeNote;
  final String refreePdf;

  RefreeNote({
    required this.refreeName,
    required this.refreeDecision,
    required this.refreeNote,
    required this.refreePdf,
  });

  factory RefreeNote.fromJson(Map<String, dynamic> json) {
    return RefreeNote(
      refreeName: json['refreeName'],
      refreeDecision: json['refreeDecision'],
      refreeNote: json['refreeNote'],
      refreePdf: json['refreePdf'],
    );
  }
}