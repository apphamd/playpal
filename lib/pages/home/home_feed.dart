import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/crud/query/filter_dogs.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/card/dog_card.dart';
import 'package:playpal/pages/components/card/filter_button.dart';
import 'package:playpal/pages/home/no_dogs.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  // Controllers
  final PageController _pageController = PageController();
  final TextEditingController _energyLevelsDropdownController =
      TextEditingController();
  final TextEditingController _weightComparisonDropdownController =
      TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _ageComparisonDropdownController =
      TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();

  // Firebase Firestore
  var db = FirebaseFirestore.instance;

  // Feed lists
  List<DogModel> _allDogs = [];
  List<DogModel> _queriedDogs = [];

  // user
  final userAuth = FirebaseAuth.instance.currentUser!;
  UserModel _currentUser = UserModel.mockUser();

  Future getCurrentUserData() async {
    await db.collection('users').doc(userAuth.uid).get().then((docSnapshot) {
      UserModel currentUser = UserModel.fromFirestore(docSnapshot);
      setState(() {
        _currentUser = currentUser;
      });
    });
    getAllDogs();
  }

  getAllDogs() async {
    List<DogModel> allDogs = [];
    await db.collection('dogs').get().then((snapshot) {
      for (var document in snapshot.docs) {
        var dog = DogModel.fromFirestore(document);
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
    filterResults(
      _energyLevelsDropdownController,
      _weightComparisonDropdownController,
      _weightTextController,
      _ageComparisonDropdownController,
      _ageTextController,
    );
  }

  void filterResults(
    TextEditingController energyLevel,
    TextEditingController weightComparison,
    TextEditingController weight,
    TextEditingController ageComparison,
    TextEditingController age,
  ) {
    setState(() {
      _queriedDogs = _allDogs;
      _queriedDogs = FilterDogs.filterByEnergyLevel(energyLevel, _queriedDogs);
      _queriedDogs =
          FilterDogs.filterByWeight(weightComparison, weight, _queriedDogs);
      _queriedDogs = FilterDogs.filterByAge(ageComparison, age, _queriedDogs);
    });
  }

  testCallback() {
    filterResults(
      _energyLevelsDropdownController,
      _weightComparisonDropdownController,
      _weightTextController,
      _ageComparisonDropdownController,
      _ageTextController,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  void didChangeDependencies() {
    getAllDogs();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _energyLevelsDropdownController.dispose();
    // _comparisonDropdownController.dispose();
    // _weightTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          _currentUser.dogs.isEmpty
              ? const NoDogsUser()
              : _queriedDogs.isEmpty
                  ? const NoDogsInArea()
                  : PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: _queriedDogs.length,
                      itemBuilder: (context, index) {
                        return DogCardPage(
                          dog: _queriedDogs[index],
                          currentUser: _currentUser,
                        );
                      },
                    ),
          _currentUser.dogs.isEmpty || _queriedDogs.isEmpty
              ? const SizedBox()
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, right: 14.0),
                    alignment: Alignment.topRight,
                    child: FilterButton(
                      test: testCallback,
                      energyLevelsDropdownController:
                          _energyLevelsDropdownController,
                      weightComparisonDropdownController:
                          _weightComparisonDropdownController,
                      weightTextController: _weightTextController,
                      ageComparisonDropdownController:
                          _ageComparisonDropdownController,
                      ageTextController: _ageTextController,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
