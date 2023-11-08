import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final List likes;
  final List dogs;
  final String userId;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.state,
    required this.likes,
    required this.dogs,
    required this.userId,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserModel(
      firstName: data?['f_name'],
      lastName: data?['l_name'],
      city: data?['city'],
      state: data?['state'],
      likes: data?['likes'] ?? [],
      dogs: data?['dogs'] ?? [],
      userId: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "f_name": firstName,
      "l_name": lastName,
      "city": city,
      "state": state,
    };
  }
}
