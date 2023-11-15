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
  const CurrentUserProfilePage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  final dogs = FirebaseFirestore.instance.collection('dogs');

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  '${widget.currentUser.firstName} ${widget.currentUser.lastName}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                UserMenuMoreButton(
                  currentUser: widget.currentUser,
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
              '\t${widget.currentUser.city}, ${widget.currentUser.state}',
              style: const TextStyle(
                fontSize: 14,
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
            child: UserAvatarPicker(
              currentUser: widget.currentUser,
            ),
          ),

          // list of dogs
          // TODO: turn this into a instagram like card system
          Container(
            padding: const EdgeInsets.only(top: 180),
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
                      if (dogData['owner_id'] == widget.currentUser.userId) {
                        userDogs.add(DogModel.fromFirestore(doc));
                      }
                    }
                  }

                  // for (var dog in widget.currentUser.dogs) {}

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
                                  builder: (context) =>
                                      AddDogPage(user: widget.currentUser),
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: userDogs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(userDogs[index].name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DogProfilePage(
                                        owner: widget.currentUser,
                                        dog: userDogs[index]),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // add dog button
                      userDogs.length == 3
                          ? Container()
                          : Container(
                              alignment: Alignment.center,
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.indigoAccent.shade400,
                                    width: 3),
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
                                      builder: (context) =>
                                          AddDogPage(user: widget.currentUser),
                                    ),
                                  );
                                },
                              ),
                            ),
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
