import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playpal/models/user_model.dart';

class UserService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static UserModel mockUser = const UserModel(
    firstName: "Mock",
    lastName: "User",
    city: "Oxford",
    state: "MS",
    likes: [],
    userId: 'MockUserId',
  );

  static UserModel getUserFromId(String userId) {
    db.collection('users').doc(userId).get().then((value) {
      UserModel user = UserModel.fromFirestore(value);
      print(user.toFirestore());
      return user;
    });

    return mockUser;
  }
}
