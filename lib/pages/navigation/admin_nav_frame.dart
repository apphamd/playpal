import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/pages/admin/console_page.dart';
import 'package:playpal/pages/admin/reports_feed.dart';
import 'package:playpal/pages/chat/conversations_page.dart';
import 'package:playpal/pages/profile/user_profile_page.dart';
import 'package:playpal/models/user_model.dart';

class AdminNavigationFrame extends StatefulWidget {
  const AdminNavigationFrame({super.key});

  @override
  State<AdminNavigationFrame> createState() => _AdminNavigationFrameState();
}

class _AdminNavigationFrameState extends State<AdminNavigationFrame> {
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
        backgroundColor: Colors.indigo[900],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.report,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.report,
              color: Colors.white,
            ),
            label: 'Reports',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
            label: 'Users',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
            ),
            label: 'Console',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const ReportsFeed(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: ConversationsPage(
            currentUser: _currentUser!,
          ),
        ),
        Container(
            color: Colors.orange,
            alignment: Alignment.center,
            child: const AdminConsolePage()),
        Container(
          alignment: Alignment.center,
          child: const CurrentUserProfilePage(),
        ),
      ][currentPageIndex],
    );
  }
}
