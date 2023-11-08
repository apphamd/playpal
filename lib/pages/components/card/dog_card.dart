import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/card/horizontal_mock_card.dart';
import 'package:playpal/pages/components/card/like_button.dart';
import 'package:playpal/pages/components/card/report_menu_button.dart';
import 'package:playpal/pages/components/profile/user_avatar.dart';
import 'package:playpal/pages/screens/match_screen.dart';
import 'package:playpal/service/user_service.dart';

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

  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference dogRef =
        FirebaseFirestore.instance.collection('dogs').doc(widget.dog.dogId);
    DocumentReference currentUserRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser.userId);

    // if current user likes dog, add userId to 'likes' array of dog
    // and add the dog's id to the current user's 'likes' array
    if (isLiked) {
      dogRef.update({
        'likes': FieldValue.arrayUnion([widget.currentUser.userId])
      });
      currentUserRef.update({
        'likes': FieldValue.arrayUnion([widget.dog.dogId])
      });
      checkLikes();
    }
    // else remove the userId from 'likes'
    else {
      dogRef.update({
        'likes': FieldValue.arrayRemove([widget.currentUser.userId])
      });
      currentUserRef.update({
        'likes': FieldValue.arrayRemove([widget.dog.dogId])
      });
    }
  }

  void checkLikes() async {
    // so i just liked a dog right?
    // lets take that dogs owner id and create a User Object from it
    List likes;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.dog.ownerId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data() as Map;
      likes = data['likes'];

      // with that user object, lets go thru that user's likes to see if they
      // liked one of my dogs!
      for (String ownedDogId in widget.currentUser.dogs) {
        for (String likedDog in likes) {
          if (ownedDogId == likedDog) {
            print('There is a match!');
            UserService.addMatch(
              widget.currentUser.userId,
              ownedDogId,
              widget.dog.ownerId,
              widget.dog.dogId,
            );

            // go to the match screen
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MatchScreen(
                      currentUser: widget.currentUser,
                      matchedUserId: widget.dog.ownerId,
                      currentUserDogId: ownedDogId,
                      matchedUserDogId: widget.dog.dogId,
                    );
                  },
                ),
              );
            }
          }
        }
      }
    });
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
                },
              ),

              // More menu
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(
                  top: 160.0,
                  right: 35.0,
                ),
                child: MenuAnchor(
                  menuChildren: <Widget>[
                    ReportMenuButton(
                      reportingUserId: widget.currentUser.userId,
                      reportedUserId: widget.dog.ownerId,
                    ),
                  ],
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              // Dog Name
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.776),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      widget.dog.name,
                      style: const TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Breed
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                  child: Text(
                    widget.dog.breed,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),

              // energy level
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 65.0, left: 20.0),
                  child: Text(
                    '${widget.dog.energyLevel} energy',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),

              // location
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 85.0, left: 20.0),
                  child: Text(
                    '${widget.dog.city}, ${widget.dog.state}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),

              // weight
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 105.0, left: 20.0),
                  child: Text(
                    '${widget.dog.weight.toString()} lbs',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),

              // age
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 125.0, left: 20.0),
                  child: Text(
                    '${widget.dog.age.toString()} ${widget.dog.ageTimespan}',
                    style: const TextStyle(
                      fontSize: 16.0,
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
