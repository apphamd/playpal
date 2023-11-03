import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/chat_page.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({
    super.key,
    required this.currentUser,
    required this.matchedUserId,
  });
  final UserModel currentUser;
  final String matchedUserId;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match!!!')),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 400),
            child: const Text('You found a match!'),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                goBackButton(context),
                const SizedBox(width: 40),
                matchButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget goBackButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey),
        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
      ),
      onPressed: () => Navigator.pop(context),
      child: const Text('Maybe Later'),
    );
  }

  Widget matchButton(BuildContext context) {
    List<UserModel> matchedUserList = [];
    Future getUser(String userId) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) => matchedUserList.add(UserModel.fromFirestore(value)));
    }

    return FutureBuilder(
      future: getUser(widget.matchedUserId),
      builder: (context, snapshot) {
        return ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(150, 50)),
          ),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recipient: matchedUserList[0],
                  currentUser: widget.currentUser,
                ),
              ),
              (route) => route.isFirst),
          child: const Text('Let\'s Chat!'),
        );
      },
    );
  }
}
