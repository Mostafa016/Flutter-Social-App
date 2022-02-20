class MessageModel {
  final String? dateTime;
  final String senderID;
  final String text;

  MessageModel({
    required this.dateTime,
    required this.senderID,
    required this.text,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : dateTime = json['dateTime'].toString(),
        senderID = json['senderID'],
        text = json['text'];

  Map<String, dynamic> toMap() => {
        'dateTime': dateTime,
        'senderID': senderID,
        'text': text,
      };
}
