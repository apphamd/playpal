import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final String userId;

  const User({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.state,
    required this.userId,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return User(
      firstName: data?['f_name'],
      lastName: data?['l_name'],
      city: data?['city'],
      state: data?['state'],
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
