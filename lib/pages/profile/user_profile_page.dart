import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_models.dart';
import 'package:playpal/models/user_models.dart';
import 'package:playpal/pages/profile/dog_profile_page.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({super.key, required this.currentUser});
  final User currentUser;

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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                'Your dogs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder(
              future: getDogs(),
              builder: ((context, snapshot) {
                if (_userDogs.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
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
                                  dog: Dog.fromFirestore(_userDogs[index])),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
