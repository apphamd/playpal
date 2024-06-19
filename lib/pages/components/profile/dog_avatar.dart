import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playpal/service/image_service.dart';

class DogAvatar extends StatefulWidget {
  const DogAvatar({
    super.key,
    required this.dogId,
    required this.radius,
  });
  final String dogId;
  final double radius;

  @override
  State<DogAvatar> createState() => _DogAvatarState();
}

class _DogAvatarState extends State<DogAvatar> {
  Uint8List? _image;
  Map<String, dynamic> dogData = {};
  CollectionReference dogs = FirebaseFirestore.instance.collection('dogs');

  void selectImage() async {
    Uint8List image = await ImageService.pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
    saveDogProfilePicture();
  }

  void saveDogProfilePicture() async {
    await ImageService.saveDogProfilePicData(
      dogId: widget.dogId,
      file: _image!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dogs.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred ${snapshot.error}'),
            );
          }
          Map currentDog = {};
          String profilePic = '';
          if (snapshot.hasData) {
            for (var dog in snapshot.data!.docs) {
              if (widget.dogId == dog.id) {
                currentDog = dog.data() as Map;
              }
            }
            currentDog['profile_pic'] == null
                ? ()
                : profilePic = currentDog['profile_pic'];
          }

          return Stack(
            children: <Widget>[
              profilePic.isNotEmpty
                  ? CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: NetworkImage(profilePic),
                      backgroundColor: Colors.white,
                    )
                  : CircleAvatar(
                      radius: widget.radius,
                      backgroundColor: Colors.grey,
                      // backgroundImage: NetworkImage(
                      //     "https://cdn0.iconfinder.com/data/icons/google-material-design-3-0/48/ic_account_circle_48px-1024.png"),
                    ),
            ],
          );
        });
  }
}
