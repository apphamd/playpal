import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_models.dart';
import 'package:playpal/models/user_models.dart';
import 'package:playpal/pages/card/horizontal_mock_card.dart';
import 'package:playpal/pages/components/like_button.dart';

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

class DogMockCard extends StatefulWidget {
  const DogMockCard({
    super.key,
    required this.dog,
    required this.currentUser,
  });
  final Dog dog;
  final User currentUser;

  @override
  State<DogMockCard> createState() => _DogMockCardState();
}

class _DogMockCardState extends State<DogMockCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference dogRef =
        FirebaseFirestore.instance.collection('dogs').doc(widget.dog.dogId);

    // if user likes dog, add userId to 'likes' array of dog
    if (isLiked) {
      dogRef.update({
        'likes': FieldValue.arrayUnion([widget.currentUser.userId])
      });
    }
    // else remove the userId from 'likes'
    else {
      dogRef.update({
        'likes': FieldValue.arrayRemove([widget.currentUser.userId])
      });
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
              Container(
                decoration: const BoxDecoration(color: Colors.lightBlue),
              ),

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
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35.0,
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
