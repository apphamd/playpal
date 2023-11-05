import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/card/horizontal_mock_card.dart';
import 'package:playpal/pages/components/card/like_button.dart';
import 'package:playpal/pages/components/profile/user_avatar.dart';
import 'package:playpal/pages/screens/match_screen.dart';

class MockCard extends StatelessWidget {
  const MockCard({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          HorizontalMockCard(color: color),
          const HorizontalMockCard(color: Colors.grey),
          const HorizontalMockCard(color: Colors.pink),
          const HorizontalMockCard(color: Colors.white),
        ],
      ),
    );
  }
}

class DogCardPage extends StatefulWidget {
  const DogCardPage({
    super.key,
    required this.dog,
    required this.currentUser,
  });
  final DogModel dog;
  final UserModel currentUser;

  @override
  State<DogCardPage> createState() => _DogCardPageState();
}

class _DogCardPageState extends State<DogCardPage> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference dogRef =
        FirebaseFirestore.instance.collection('dogs').doc(widget.dog.dogId);
    DocumentReference dogOwnerRef =
        FirebaseFirestore.instance.collection('users').doc(widget.dog.ownerId);

    // if user likes dog, add userId to 'likes' array of dog
    if (isLiked) {
      dogRef.update({
        'likes': FieldValue.arrayUnion([widget.currentUser.userId])
      });
      dogOwnerRef.update({
        'likes': FieldValue.arrayUnion([
          {'user': widget.currentUser.userId, 'dog': widget.dog.dogId}
        ])
      });
      checkLikes();
    }
    // else remove the userId from 'likes'
    else {
      dogRef.update({
        'likes': FieldValue.arrayRemove([widget.currentUser.userId])
      });
      dogOwnerRef.update({
        'likes': FieldValue.arrayRemove([
          {'user': widget.currentUser.userId, 'dog': widget.dog.dogId}
        ])
      });
    }
  }

  void checkLikes() {
    for (var map in widget.currentUser.likes!) {
      var dog = map['dog'];
      var user = map['user'];
      print('UserID: $user \t DogID: $dog');
      if (widget.dog.ownerId == user) {
        print('Congratulations! You found a pal!');

        DocumentReference currentUserRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUser.userId)
            .collection('matches')
            .doc();

        currentUserRef.set({
          'matched_user_id': widget.dog.ownerId,
          'dog_id': widget.dog.dogId
        });

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MatchScreen(
              currentUser: widget.currentUser,
              matchedUserId: user,
            );
          },
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: toggleLike,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.25,
              color: Colors.black,
            ),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // Card Image
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('dogs')
                    .doc(widget.dog.dogId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  Map dogData = snapshot.data!.data() as Map;
                  if (dogData['profile_pic'] != null) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                          image: NetworkImage(dogData['profile_pic']),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                    );
                  }

                  // return profilePic.isNotEmpty
                  //     ? Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.lightBlue,
                  //             image: DecorationImage(
                  //                 image: NetworkImage(profilePic))),
                  //       )
                  //     : Container(
                  //         decoration: const BoxDecoration(
                  //           color: Colors.lightBlue,
                  //         ),
                  //       );
                },
              ),

              // More menu
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(
                  top: 50.0,
                  right: 10.0,
                ),
                child: const Icon(
                  Icons.more_horiz,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              // Dog Name
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    widget.dog.name,
                    style: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // User Profile Circle
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                  alignment: Alignment.topRight,
                  child: Stack(
                    children: <Widget>[
                      UserAvatar(
                        userId: widget.dog.ownerId,
                        radius: 35.0,
                      ),
                    ],
                  ),
                ),
              ),

              // Like Button
              Container(
                padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                alignment: Alignment.bottomRight,
                child: LikeButton(
                  isLiked: isLiked,
                  onTap: toggleLike,
                  size: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
