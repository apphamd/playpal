import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final List likes;
  final List dogs;
  final DateTime birthday;
  final String profilePic;
  final String userId;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.state,
    required this.likes,
    required this.dogs,
    required this.birthday,
    required this.profilePic,
    required this.userId,
  });

  static UserModel mockUser() {
    return UserModel(
      firstName: 'firstName',
      lastName: 'lastName',
      city: 'city',
      state: 'state',
      likes: [],
      dogs: ['dogId'],
      birthday: DateTime.now(),
      profilePic: 'profile pic',
      userId: 'userId',
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    Timestamp birthday = data?['birthday'];

    return UserModel(
      firstName: data?['f_name'],
      lastName: data?['l_name'],
      city: data?['city'],
      state: data?['state'],
      likes: data?['likes'] ?? [],
      dogs: data?['dogs'] ?? [],
      birthday: birthday.toDate(),
      profilePic: data?['profile_pic'] ?? '',
      userId: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "f_name": firstName,
      "l_name": lastName,
      "city": city,
      "state": state,
      "likes": likes,
      "dogs": dogs,
      "birthday": birthday,
      "profile_pic": profilePic,
    };
  }
}
