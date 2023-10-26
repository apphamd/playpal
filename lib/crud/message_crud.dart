import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:playpal/models/message_model.dart';

class MessageCrud {
  static final db = FirebaseFirestore.instance;

  static Future<void> createMessage({
    required String content,
    required String senderId,
    required String recipientId,
  }) async {
    final message = MessageModel(
      content: content,
      senderId: senderId,
      recipientId: recipientId,
      timestamp: Timestamp.now(),
      messageType: MessageType.text,
    );
    await addMessageToChat(message, senderId, recipientId);
  }

  static String generateChatRoomId(
    String senderId,
    String recipientId,
  ) {
    List<String> ids = [senderId, recipientId];
    ids.sort();
    return ids.join("_");
  }

  static Future<void> addMessageToChat(
    MessageModel message,
    String senderId,
    String recipientId,
  ) async {
    String chatRoomId = generateChatRoomId(senderId, recipientId);

    await db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toFirestore());
  }

  static Stream<QuerySnapshot> getMessages(
    String currentUserId,
    String recipientId,
  ) {
    String chatRoomId = generateChatRoomId(currentUserId, recipientId);
    return db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);
  }
}
