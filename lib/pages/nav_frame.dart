import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/pages/home_feed.dart';
import 'package:playpal/pages/user_profile_page.dart';

class NavigationFrame extends StatefulWidget {
  const NavigationFrame({super.key});

  @override
  State<NavigationFrame> createState() => _NavigationFrameState();
}

class _NavigationFrameState extends State<NavigationFrame> {
  final userAuth = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData = {};

  int currentPageIndex = 0;

  Future getCurrentUserData() async {
    Map<String, dynamic>? userData;
    await db.collection('users').doc(userAuth.uid).get().then((docSnapshot) {
      userData = docSnapshot.data();
    });
    setState(() {
      _userData = userData;
    });
    debugPrint('User Data: $_userData');
  }

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message_outlined),
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_outlined),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const HomeFeed(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page 2'),
        ),
        Container(
          alignment: Alignment.center,
          child: CurrentUserProfilePage(
            currentUserData: _userData!,
            currentUserId: userAuth.uid,
          ),
        ),
      ][currentPageIndex],
    );
  }
}
