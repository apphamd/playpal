import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/pages/profile/dog_profile_page.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage(
      {super.key, required this.currentUserData, required this.currentUserId});
  final Map<String, dynamic> currentUserData;
  final String currentUserId;

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  final dogs = FirebaseFirestore.instance.collection('dogs');
  List<Map<String, dynamic>> _userDogs = [];

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  Future getDogs() async {
    _userDogs = [];
    await dogs.get().then((snapshot) => snapshot.docs.forEach((document) {
          if (document.data()['owner_id'] == widget.currentUserId) {
            _userDogs.add(document.data());
          }
        }));
    print(_userDogs.toList());
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
              '${widget.currentUserData['f_name']} ${widget.currentUserData['l_name']} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.currentUserData['city']}, ${widget.currentUserData['state']}',
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
                    return const Text('Loading...');
                  }
                  return ListView.builder(
                    itemCount: _userDogs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DogProfilePage(data: _userDogs[index]),
                                ));
                          },
                          title: Text(_userDogs[index]['f_name']),
                        ),
                      );
                    },
                  );
                })),
          )
        ],
      ),
    );
  }
}
