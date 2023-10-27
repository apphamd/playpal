import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future getUser(String userId) async {
    await db.collection('users').doc(userId).get();
  }
}
