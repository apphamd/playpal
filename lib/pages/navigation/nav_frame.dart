import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/pages/chat/conversations_page.dart';
import 'package:playpal/pages/home/home_feed.dart';
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

  int currentPageIndex = 1;

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
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      // extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black54, width: 0.2),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.indigo[900],
          height: 60,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            // inbox icon
            NavigationDestination(
              selectedIcon: Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Icon(
                  Icons.message,
                  size: 25,
                  color: Colors.amber,
                ),
              ),
              icon: Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Icon(
                  Icons.message_outlined,
                  size: 25,
                  color: Colors.white70,
                ),
              ),
              label: 'Inbox',
            ),

            // home icon
            NavigationDestination(
              selectedIcon: Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Icon(
                  Icons.home,
                  size: 50,
                  color: Colors.amber,
                ),
              ),
              icon: Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Icon(
                  Icons.home_outlined,
                  size: 50,
                  color: Colors.white70,
                ),
              ),
              label: '',
            ),

            // profile icon
            NavigationDestination(
              selectedIcon: Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Icon(
                  Icons.account_circle,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
              icon: Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white70,
                  size: 30,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: <Widget>[
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: ConversationsPage(
            currentUser: _currentUser!,
          ),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const HomeFeed(),
        ),
        Container(
          alignment: Alignment.center,
          child: const CurrentUserProfilePage(),
        ),
      ][currentPageIndex],
    );
  }
}
