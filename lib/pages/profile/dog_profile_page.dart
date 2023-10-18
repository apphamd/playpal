import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/models/dog_models.dart';

class DogProfilePage extends StatelessWidget {
  const DogProfilePage({super.key, required this.dog});
  final Dog? dog;

  @override
  Widget build(BuildContext context) {
    if (dog == null) {
      return const Text('Loading...');
    }
    return Scaffold(
        appBar: AppBar(title: Text(dog!.name)),
        body: Center(
          child: Column(
            children: [
              Text('Breed: ${dog!.breed}'),
              Text('Energy Level: ${dog!.energyLevel}'),
              Text('Weight: ${dog!.weight}'),
            ],
          ),
        ));
  }
}
