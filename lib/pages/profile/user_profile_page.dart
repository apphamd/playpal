import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/crud/create/add_dog.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/profile/dog_profile_page.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  final dogs = FirebaseFirestore.instance.collection('dogs');
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _userDogs = [];

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  Future getDogs() async {
    _userDogs = [];
    await dogs.get().then((snapshot) => snapshot.docs.forEach((document) {
          if (document.data()['owner_id'] == widget.currentUser.userId) {
            _userDogs.add(document);
          }
        }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: userSignOut, icon: const Icon(Icons.logout))
        ],
        title: Column(
          children: [
            Text(
              '${widget.currentUser.firstName} ${widget.currentUser.lastName} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.currentUser.city}, ${widget.currentUser.state}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: Stack(
        children: [
          // "your dogs"
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            child: const Text(
              'Your dogs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),

          // list of dogs
          // TODO: turn this into a instagram like card system
          Container(
            padding: EdgeInsets.only(top: 50),
            child: FutureBuilder(
              future: getDogs(),
              builder: ((context, snapshot) {
                if (_userDogs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _userDogs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_userDogs[index]['f_name']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DogProfilePage(
                                      dog: DogModel.fromFirestore(
                                          _userDogs[index])),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
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
                                  AddDog(user: widget.currentUser),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
