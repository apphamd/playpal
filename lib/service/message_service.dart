import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:playpal/models/message_model.dart';

class MessageService {
  static final _db = FirebaseFirestore.instance;

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

    await _db
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
    return _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  static void deleteMatch(
    String currentUserId,
    String recipientId,
  ) async {
    String chatRoomId = generateChatRoomId(currentUserId, recipientId);
    print(chatRoomId);
    _db.runTransaction((transaction) async =>
        transaction.delete(_db.collection('chat_rooms').doc(chatRoomId)));
    _db.runTransaction((transaction) async => transaction.delete(_db
        .collection('users')
        .doc(currentUserId)
        .collection('matches')
        .doc(recipientId)));
    _db.runTransaction((transaction) async => transaction.delete(_db
        .collection('users')
        .doc(recipientId)
        .collection('matches')
        .doc(currentUserId)));
  }
}
