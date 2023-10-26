import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/chat_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final usersDb = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder(
        stream: usersDb.snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // create a list of users.
            // then, for each user in the database
            // if it is not the current user, add it to the list of users
            List<UserModel> usersList = [];
            for (var doc in snapshot.data!.docs) {
              UserModel user = UserModel.fromFirestore(doc);
              if (user.userId != widget.currentUser.userId) usersList.add(user);
            }
            return ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                // each card represents a chat between the current user and
                // the user listed on the card
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                              recipient: usersList[index],
                              currentUser: widget.currentUser),
                        ),
                      );
                    },
                    title: Text(
                        '${usersList[index].firstName} ${usersList[index].lastName}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
