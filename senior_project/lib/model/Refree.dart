class Refree {
  final String refreeID;
  final String nameSurname;

  Refree({
    required this.refreeID,
    required this.nameSurname,

  });

  factory Refree.fromJson(Map<String, dynamic> json) {
    return Refree(
      refreeID: json['refreeID'],
      nameSurname: json['Name_Surname'],
    );
  }
}

