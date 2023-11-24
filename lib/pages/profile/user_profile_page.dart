import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/pages/components/profile/user_more_menu_button.dart';
import 'package:playpal/pages/profile/add_dog_page.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/profile/user_avatar_picker.dart';
import 'package:playpal/pages/profile/dog_profile_page.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({super.key});

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  final dogs = FirebaseFirestore.instance.collection('dogs');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // user
  final userAuth = FirebaseAuth.instance.currentUser!;
  UserModel _currentUser = UserModel.mockUser();

  Future getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth.uid)
        .get()
        .then((docSnapshot) {
      UserModel currentUser = UserModel.fromFirestore(docSnapshot);
      setState(() {
        _currentUser = currentUser;
      });
    });
  }

  void setCurrentUserData(UserModel updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  void addDog(String dogId) {
    List dogsList = _currentUser.dogs;
    if (!dogsList.contains(dogId)) {
      print(dogId);
      dogsList.add(dogId);
    }
    setState(() {
      _currentUser = UserModel(
        firstName: _currentUser.firstName,
        lastName: _currentUser.lastName,
        city: _currentUser.city,
        state: _currentUser.state,
        dogs: dogsList,
        likes: _currentUser.likes,
        birthday: _currentUser.birthday,
        profilePic: _currentUser.profilePic,
        userId: _currentUser.userId,
      );
    });
    print(_currentUser.dogs);
  }

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black45, Colors.white10],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // User's name
                Text(
                  '${_currentUser.firstName} ${_currentUser.lastName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                UserMenuMoreButton(
                  currentUser: _currentUser,
                  updateUser: setCurrentUserData,
                ),
                IconButton(
                  onPressed: userSignOut,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Text(
              _currentUser.userId == ''
                  ? ''
                  : '${_currentUser.city}, ${_currentUser.state}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20),
            child: _currentUser.userId == ''
                ? const CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.white,
                    child: CircularProgressIndicator(),
                  )
                : UserAvatarPicker(
                    currentUser: _currentUser,
                  ),
          ),

          // list of dogs
          // TODO: turn this into a instagram like card system
          Container(
            padding: const EdgeInsets.only(top: 260),
            child: StreamBuilder(
              stream: dogs.snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  List<DogModel> userDogs = [];

                  if (snapshot.data != null) {
                    for (var doc in snapshot.data!.docs) {
                      Map dogData = doc.data();
                      if (dogData['owner_id'] == _currentUser.userId) {
                        userDogs.add(DogModel.fromFirestore(doc));
                      }
                    }
                  }

                  // no dogs
                  if (userDogs.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 50),
                        const Center(
                            child: Text('Uh oh, where are your buddies at?')),
                        const SizedBox(height: 50),
                        Container(
                          alignment: Alignment.center,
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.indigoAccent.shade400, width: 3),
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 20,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddDogPage(
                                    user: _currentUser,
                                    addDog: addDog,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  // has dogs
                  return Column(
                    children: [
                      const SizedBox(height: 10),

                      // grid system for the doggies
                      CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return index == userDogs.length
                                    ?
                                    // add dog button
                                    userDogs.length == 3
                                        ? Container()
                                        : Container(
                                            alignment: Alignment.center,
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors
                                                      .indigoAccent.shade400,
                                                  width: 2),
                                              color: Colors
                                                  .blue[100 * (index + 2)],
                                            ),
                                            child: IconButton(
                                              color: Colors.amber,
                                              iconSize: 70,
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddDogPage(
                                                      user: _currentUser,
                                                      addDog: addDog,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                    : GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DogProfilePage(
                                              dog: userDogs[index],
                                              owner: _currentUser,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.blue[100 * (index + 1)],
                                          child: Text(
                                            userDogs[index].name,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      );
                              },
                              childCount: userDogs.length + 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  );
                } else {
                  return const Center(child: Text('An error has occurred'));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
