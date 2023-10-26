import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String recipientId;
  final String content;
  final Timestamp timestamp;
  final MessageType messageType;

  const MessageModel({
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    required this.messageType,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'recipientId': recipientId,
      'timestamp': timestamp,
      'content': content,
      'messageType': messageType.toJson()
    };
  }

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return MessageModel(
      senderId: data?['senderId'],
      recipientId: data?['recipientId'],
      timestamp: data?['timestamp'],
      content: data?['content'],
      messageType: MessageType.values.byName(data?['messageType']),
    );
  }
}

enum MessageType {
  text,
  image;

  String toJson() => name;
}
