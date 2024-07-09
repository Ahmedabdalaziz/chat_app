import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final DateTime dateTime;

  Message(this.message, this.id, this.dateTime);

  factory Message.fromJson(jsonData) {
    return Message(
      jsonData['message'] ?? '',
      jsonData['id'] ?? '',
      (jsonData['date'] as Timestamp).toDate(),
    );
  }
}
