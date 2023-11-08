import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/chat_page.dart';
import 'package:playpal/pages/components/profile/dog_avatar.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({
    super.key,
    required this.currentUser,
    required this.matchedUserId,
    required this.currentUserDogId,
    required this.matchedUserDogId,
  });
  final UserModel currentUser;
  final String matchedUserId;
  final String currentUserDogId;
  final String matchedUserDogId;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  String _currentUserDogName = '';
  String _matchedUserDogName = '';
  String _matchedUserName = '';

  Future getDogNames() async {
    await FirebaseFirestore.instance
        .collection('dogs')
        .doc(widget.currentUserDogId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data() as Map;
      setState(() {
        _currentUserDogName = data['f_name'];
      });
    });
    await FirebaseFirestore.instance
        .collection('dogs')
        .doc(widget.matchedUserDogId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data() as Map;
      setState(() {
        _matchedUserDogName = data['f_name'];
      });
    });
  }

  Future getMatchedUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.matchedUserId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data() as Map;
      setState(() {
        _matchedUserName = data['f_name'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDogNames();
    getMatchedUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(color: Colors.blueGrey[400]),
          // ),

          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(bottom: 250),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 250,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: Text(
                        'You and $_matchedUserName have liked each other\'s dogs!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // buttons
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(bottom: 60),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  matchButton(context),
                  const SizedBox(height: 20),
                  goBackButton(context),
                ],
              ),
            ),
          ),

          // Current user's dog
          Container(
            padding: const EdgeInsets.only(top: 95, left: 25),
            child: Column(
              children: [
                Text(
                  _currentUserDogName,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                DogAvatar(dogId: widget.currentUserDogId, radius: 100)
              ],
            ),
          ),

          // Matched user's dog
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 245, right: 25),
            child: Column(
              children: [
                DogAvatar(dogId: widget.matchedUserDogId, radius: 100),
                const SizedBox(height: 10),
                Text(
                  _matchedUserDogName,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 260),
            alignment: Alignment.topCenter,
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 70,
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
        fixedSize: MaterialStateProperty.all(const Size(230, 50)),
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
            fixedSize: MaterialStateProperty.all(const Size(230, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.amber[800]),
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
