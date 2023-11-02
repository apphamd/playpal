import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/crud/user_service.dart';
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
  List _matches = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usersDb = FirebaseFirestore.instance.collection('users');
    final matchesDb = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser.userId)
        .collection('matches');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder(
        stream: matchesDb.snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // create a list of ids from matches.
            List matchIdList = [];
            for (var doc in snapshot.data!.docs) {
              var data = doc.data();
              if (!matchIdList.contains(data['matched_user_id'])) {
                matchIdList.add(data['matched_user_id']);
              }
            }

            if (matchIdList.isEmpty) {
              return const Center(
                  child:
                      Text('No matches! Go out there and find some friends!'));
            } else {
              return StreamBuilder(
                stream: usersDb.snapshots(includeMetadataChanges: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // build a list of matched users from matchIdList
                  List<UserModel> matchedUsersList = [];
                  for (var doc in snapshot.data!.docs) {
                    for (var id in matchIdList) {
                      UserModel user = UserModel.fromFirestore(doc);
                      if (id == doc.id && !matchedUsersList.contains(user)) {
                        matchedUsersList.add(user);
                      }
                    }
                  }

                  return ListView.builder(
                    itemCount: matchedUsersList.length,
                    itemBuilder: (context, index) {
                      if (matchedUsersList.isEmpty) {
                        return const Center(
                            child: Text(
                                'No matches! Go out there and find some friends!'));
                      } else {
                        // each card represents a chat between the current user and
                        // the user listed on the card
                        return Card(
                          child: ListTile(
                            minVerticalPadding: 40,
                            leading: const Icon(Icons.account_circle_outlined,
                                size: 60),
                            minLeadingWidth: 8,
                            title: Text(
                                '${matchedUsersList[index].firstName} ${matchedUsersList[index].lastName}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    recipient: matchedUsersList[index],
                                    currentUser: widget.currentUser,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
