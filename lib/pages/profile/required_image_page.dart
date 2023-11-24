import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/pages/components/profile/dog_profile_image_picker.dart';
import 'package:playpal/pages/profile/user_profile_page.dart';
import 'package:playpal/service/image_service.dart';

class RequiredImagePage extends StatefulWidget {
  const RequiredImagePage({
    super.key,
    required this.addDogFormState,
    required this.submitForm,
  });
  final FormState? addDogFormState;
  final Function submitForm;

  @override
  State<RequiredImagePage> createState() => _RequiredImagePageState();
}

class _RequiredImagePageState extends State<RequiredImagePage> {
  Uint8List? _image;
  Map<String, dynamic> dogData = {};
  CollectionReference dogs = FirebaseFirestore.instance.collection('dogs');
  final GlobalKey<FormState> _addDogFormKey = GlobalKey<FormState>();

  void selectImage() async {
    Uint8List image = await ImageService.pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void saveDogProfilePicture() async {
    if (_image != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Adding dog...'),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      String dogId = await widget.submitForm();
      await ImageService.saveDogProfilePicData(
        dogId: dogId,
        file: _image!,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An image is required to add your dog.'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new pal')),
      body: Form(
        key: _addDogFormKey,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 100),
                child: Stack(
                  children: <Widget>[
                    _image == null
                        ? const CircleAvatar(
                            radius: 125,
                            backgroundColor: Colors.white,
                          )
                        : CircleAvatar(
                            radius: 125,
                            backgroundImage: MemoryImage(_image!),
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
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 140),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(100, 60))),
                  onPressed: saveDogProfilePicture,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 250),
                child: const SizedBox(
                  width: 200,
                  child: Text(
                    'You must upload an image of your dog to continue!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
