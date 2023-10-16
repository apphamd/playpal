import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DogProfilePage extends StatelessWidget {
  const DogProfilePage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(data['f_name'])),
        body: Center(
          child: Column(
            children: [
              Text('Breed: ${data['breed']}'),
              Text('Energy Level: ${data['energy_level']}'),
              Text('Weight: ${data['weight']}'),
            ],
          ),
        ));
  }
}
