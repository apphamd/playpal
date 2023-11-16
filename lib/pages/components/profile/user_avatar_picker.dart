import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playpal/service/image_service.dart';
import 'package:playpal/models/user_model.dart';

class UserAvatarPicker extends StatefulWidget {
  const UserAvatarPicker({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<UserAvatarPicker> createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  Uint8List? _image;
  Map<String, dynamic> userData = {};
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void selectImage() async {
    Uint8List image = await ImageService.pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
    saveProfilePicture();
  }

  void saveProfilePicture() async {
    await ImageService.saveUserProfilePicData(
      userId: widget.currentUser.userId,
      file: _image!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('An error has occured ${snapshot.error}'),
          );
        }
        Map currentUser = {};
        String profilePic = '';
        if (snapshot.hasData) {
          for (var user in snapshot.data!.docs) {
            if (widget.currentUser.userId == user.id) {
              currentUser = user.data() as Map;
            }
          }
          currentUser['profile_pic'] == null
              ? ()
              : profilePic = currentUser['profile_pic'];
        }

        return Stack(
          children: <Widget>[
            profilePic.isNotEmpty
                ? CircleAvatar(
                    radius: 72,
                    backgroundImage: NetworkImage(profilePic),
                    backgroundColor: Colors.white,
                  )
                : const CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.grey,
                    // backgroundImage: NetworkImage(
                    //     "https://cdn0.iconfinder.com/data/icons/google-material-design-3-0/48/ic_account_circle_48px-1024.png"),
                  ),
            Positioned(
              bottom: 0,
              right: 7,
              child: IconButton(
                onPressed: selectImage,
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.amber[600],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
