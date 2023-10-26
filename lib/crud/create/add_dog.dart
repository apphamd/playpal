import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';

class AddDog extends StatefulWidget {
  AddDog({super.key, required this.user});
  final UserModel user;

  @override
  State<AddDog> createState() => _AddDogState();
}

class _AddDogState extends State<AddDog> {
  final GlobalKey<FormState> _addDogFormKey = GlobalKey<FormState>();

  // dog fields
  String dogName = '';
  String breed = '';
  String energyLevel = '';
  int weight = 0;
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new pal')),
      body: Form(
        key: _addDogFormKey,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                child: _buildName(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 70),
                child: _buildBreed(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 140),
                child: _buildEnergyLevel(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 210),
                child: _buildWeight(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 280),
                child: _buildAge(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
        onSaved: (String? value) {
          dogName = value!;
        },
      ),
    );
  }

  Widget _buildBreed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Breed',
          border: OutlineInputBorder(),
        ),
        onSaved: (String? value) {
          breed = value!;
        },
      ),
    );
  }

  Widget _buildEnergyLevel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Energy Level',
          border: OutlineInputBorder(),
        ),
        onSaved: (String? value) {
          energyLevel = value!;
        },
      ),
    );
  }

  Widget _buildWeight() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Weight',
          border: OutlineInputBorder(),
        ),
        onSaved: (String? value) {
          weight = int.parse(value!.trim());
        },
      ),
    );
  }

  Widget _buildAge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Age',
          border: OutlineInputBorder(),
        ),
        onSaved: (String? value) {
          age = int.parse(value!.trim());
        },
      ),
    );
  }
}
