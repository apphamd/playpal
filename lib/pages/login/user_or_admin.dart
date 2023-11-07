import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/pages/navigation/admin_nav_frame.dart';
import 'package:playpal/pages/navigation/nav_frame.dart';

class UserOrAdmin extends StatelessWidget {
  const UserOrAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admins').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
                return const AdminNavigationFrame();
              }
            }
            return const NavigationFrame();
          }
          return const NavigationFrame();
        },
      ),
    );
  }
}
