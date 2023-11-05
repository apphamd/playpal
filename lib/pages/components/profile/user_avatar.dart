import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
    required this.userId,
    required this.radius,
  });
  final String userId;
  final double radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Map<String, dynamic> userData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occured ${snapshot.error}'),
            );
          }
          var currentUser = {};
          String profilePic = '';
          if (snapshot.hasData) {
            for (DocumentSnapshot user in snapshot.data!.docs) {
              if (widget.userId == user.id) {
                currentUser = user.data() as Map;
              }
            }
            currentUser['profile_pic'] == null
                ? ()
                : profilePic = currentUser['profile_pic'];
          }

          return Stack(
            children: <Widget>[
              profilePic != ''
                  ? CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: NetworkImage(profilePic),
                      backgroundColor: Colors.white,
                    )
                  : CircleAvatar(
                      radius: widget.radius,
                      backgroundColor: Colors.white,
                      backgroundImage: const NetworkImage(
                          "https://cdn0.iconfinder.com/data/icons/google-material-design-3-0/48/ic_account_circle_48px-1024.png"),
                    ),
            ],
          );
        });
  }
}
