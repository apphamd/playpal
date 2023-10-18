import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_models.dart';
import 'package:playpal/models/user_models.dart';
import 'package:playpal/pages/card/mock_card.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key, required this.user});
  final User user;

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  // Controllers
  final PageController _pageController = PageController();

  // Firebase Firestore
  var db = FirebaseFirestore.instance;

  // Feed lists
  List<Dog> _allDogs = [];
  List<Dog> _queriedDogs = [];

  // user
  late User _currentUser;

  getAllDogs() async {
    List<Dog> allDogs = [];
    await db.collection('dogs').get().then((snapshot) {
      for (var document in snapshot.docs) {
        var dog = Dog.fromFirestore(document);
        if (dog.ownerId != _currentUser.userId &&
            dog.city == _currentUser.city &&
            dog.state == _currentUser.state) {
          allDogs.add(dog);
        }
      }
    });
    setState(() {
      allDogs.shuffle();
      _allDogs = allDogs;
      _queriedDogs = allDogs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDogs();
    setState(() {
      _currentUser = widget.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Location: ${_currentUser.city}, ${_currentUser.state}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          leading: const Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Icon(Icons.filter_alt, size: 30.0),
          ),
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _allDogs.length,
        itemBuilder: (context, index) {
          return DogMockCard(
            dog: _allDogs[index],
            currentUser: _currentUser,
          );
        },
      ),
    );
  }
}
