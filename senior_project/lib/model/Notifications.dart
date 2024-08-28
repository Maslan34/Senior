class Notifications{
  final String Title;
  final DateTime Time;
  final String Text;
  bool isShowed=false;
  bool isReaden;


  Notifications({
    required this.Title,
    required this.Time,
    required this.Text,
    required this.isReaden,
  });


  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      Title: json['title'],
      Time: DateTime.parse(json['time'] as String),
      Text: json['text'],
      isReaden: json['isReaden'],

    );
  }

}

