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
    dogs: [],
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

  static void addMatch(
    String currentUserId,
    String currentUserDogId,
    String matchedUserId,
    String matchedDogId,
  ) {
    // If there is a match, add a document in the user's matches collection
    // this document id is the same as the matched user's id
    // this is to ensure that there are no duplicate matches
    DocumentReference currentUserMatchesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('matches')
        .doc(matchedUserId);

    currentUserMatchesRef.set({'dog_id': matchedDogId});

    // And do the same thing here, except your id is now going to be
    // the id of the document created in the matched user's 'matches'
    // collection.
    DocumentReference matchedUserMatchesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(matchedUserId)
        .collection('matches')
        .doc(currentUserId);

    matchedUserMatchesRef.set({'dog_id': currentUserDogId});
  }
}
