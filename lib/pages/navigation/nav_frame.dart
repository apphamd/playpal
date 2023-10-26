import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/pages/chat/conversations_page.dart';
import 'package:playpal/pages/home/home_feed.dart';
import 'package:playpal/pages/home/home_feed_mock.dart';
import 'package:playpal/pages/profile/user_profile_page.dart';
import 'package:playpal/models/user_model.dart';

class NavigationFrame extends StatefulWidget {
  const NavigationFrame({super.key});

  @override
  State<NavigationFrame> createState() => _NavigationFrameState();
}

class _NavigationFrameState extends State<NavigationFrame> {
  final userAuth = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  UserModel? _currentUser;

  int currentPageIndex = 0;

  Future getCurrentUserData() async {
    await db.collection('users').doc(userAuth.uid).get().then((docSnapshot) {
      UserModel currentUser = UserModel.fromFirestore(docSnapshot);
      setState(() {
        _currentUser = currentUser;
      });
    });
  }

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser?.userId == null) {
      return const Text('loading...');
    }
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
          child: HomeFeed(user: _currentUser!),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: ConversationsPage(
            currentUser: _currentUser!,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: CurrentUserProfilePage(
            currentUser: _currentUser!,
          ),
        ),
      ][currentPageIndex],
    );
  }
}
