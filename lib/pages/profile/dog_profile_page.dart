import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/profile/delete_dog_button.dart';
import 'package:playpal/pages/components/profile/dog_profile_image_picker.dart';
import 'package:playpal/pages/profile/edit_dog_page.dart';

class DogProfilePage extends StatefulWidget {
  const DogProfilePage({
    super.key,
    required this.dog,
    required this.owner,
  });
  final UserModel owner;
  final DogModel dog;

  @override
  State<DogProfilePage> createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          leadingWidth: 30.0,
          leading: const BackButton(color: Colors.black),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black45, Colors.white10],
              ),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditDogPage(user: widget.owner, dog: widget.dog),
                  ),
                ),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.dog.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                ' ${widget.dog.breed}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(50.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  child: DogProfileImagePicker(
                    dog: widget.dog,
                  ),
                ),
              ),
              Text('Breed: ${widget.dog.breed}'),
              Text('Energy Level: ${widget.dog.energyLevel}'),
              Text('Weight: ${widget.dog.weight}'),
              DeleteDogButton(
                dogId: widget.dog.dogId,
              ),
            ],
          ),
        ));
  }
}
