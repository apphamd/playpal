import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/service/dog_service.dart';

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static UserModel updateUser(
    UserModel user,
    String firstName,
    String lastName,
    String city,
    String state,
    DateTime birthday,
  ) {
    UserModel updatedUser = UserModel(
      firstName: firstName,
      lastName: lastName,
      city: city,
      state: state,
      likes: user.likes,
      dogs: user.dogs,
      birthday: birthday,
      profilePic: user.profilePic,
      userId: user.userId,
    );
    _db.collection('users').doc(user.userId).set(updatedUser.toFirestore());
    return updatedUser;
  }

  static deleteAllDogs(UserModel user) async {
    for (var dogId in user.dogs) {
      print(dogId);
      await DogService.deleteDog(dogId, user.userId);
    }
  }

  static Future<void> reauthenticateUser() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  static void deleteUser(
    UserModel user,
  ) async {
    // Try to delete the user
    // on requires recent login code
    // makes user reauthenticate
    try {
      await deleteAllDogs(user);
      FirebaseAuth.instance.currentUser?.delete();
      _db.runTransaction((transaction) async =>
          transaction.delete(_db.collection('users').doc(user.userId)));
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await reauthenticateUser();
      }
    }
  }

  static UserModel getUserFromId(String userId) {
    _db.collection('users').doc(userId).get().then((value) {
      UserModel user = UserModel.fromFirestore(value);
      print(user.toFirestore());
      return user;
    });

    return UserModel.mockUser();
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
