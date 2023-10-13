import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListUser extends StatelessWidget {
  const ListUser({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
              '${data['f_name']} ${data['l_name']} | ${data['city']}, ${data['state']}');
        }
        return const Text('Loading...');
      },
    );
  }
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String city;
  final String state;

  const UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.city,
      required this.state});

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserProfile(
      firstName: data?['f_name'],
      lastName: data?['l_name'],
      city: data?['city'],
      state: data?['state'],
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
