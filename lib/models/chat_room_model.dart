import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String? lastMessageDateTime;
  final DocumentReference? lastMessageRef;
  final List<DocumentReference> users;
  int numOfMessages;
  final String id;

  ChatRoomModel({
    required this.lastMessageDateTime,
    required this.lastMessageRef,
    required this.users,
    required this.numOfMessages,
    required this.id,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : lastMessageDateTime = json['lastMessageDateTime'].toString(),
        lastMessageRef = json['lastMessageRef'],
        users = List<DocumentReference>.from(json['users']),
        numOfMessages = json['numOfMessages'],
        id = json['id'];

  Map<String, dynamic> toMap() => {
        'lastMessageDateTime': lastMessageDateTime,
        'lastMessageRef': lastMessageRef,
        'users': users,
        'numOfMessages': numOfMessages,
        'id': id,
      };
}
