import 'package:flutter/material.dart';
import 'package:playpal/service/dog_service.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';

class EditDogPage extends StatefulWidget {
  EditDogPage({
    super.key,
    required this.user,
    required this.dog,
  });
  final UserModel user;
  final DogModel dog;

  @override
  State<EditDogPage> createState() => _EditDogPageState();
}

class _EditDogPageState extends State<EditDogPage> {
  final GlobalKey<FormState> _addDogFormKey = GlobalKey<FormState>();
  final DogService dogService = DogService();

  // dog fields
  String dogName = '';
  String breed = '';
  String energyLevel = '';
  int weight = 0;
  int age = 0;
  String ageTimespan = '';

  void submitForm() {
    if (context.mounted) FocusScope.of(context).unfocus();
    _addDogFormKey.currentState!.save();
    print('$dogName $breed $energyLevel $weight $age $ageTimespan');
    dogService.updateDog(
      widget.dog.dogId,
      widget.user,
      dogName,
      breed,
      energyLevel,
      weight,
      age,
      ageTimespan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.dog.name}')),
      body: Form(
        key: _addDogFormKey,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                child: _buildName(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 90),
                child: _buildBreed(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 180),
                child: _buildEnergyLevel(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 270),
                child: _buildWeight(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 360),
                child: _buildAge(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 150),
                child: ElevatedButton(
                    child: const Text('Update Dog!'),
                    onPressed: () {
                      if (_addDogFormKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        submitForm();
                      }
                    }),
              )
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
        initialValue: widget.dog.name,
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
        initialValue: widget.dog.breed,
        onSaved: (String? value) {
          breed = value!;
        },
      ),
    );
  }

  Widget _buildEnergyLevel() {
    final List<DropdownMenuItem<EnergyLevel>> energyLevelEntries =
        <DropdownMenuItem<EnergyLevel>>[];
    for (final EnergyLevel energy in EnergyLevel.values) {
      if (energy.level != 'all') {
        energyLevelEntries.add(
          DropdownMenuItem<EnergyLevel>(
              value: energy, child: Text(energy.level)),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: Column(
        children: [
          DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Please select a value';
              }
              return null;
            },
            hint: const Text('Energy Level'),
            items: energyLevelEntries,
            onChanged: (value) => {},
            onSaved: (newValue) {
              energyLevel = newValue!.getLevel();
            },
          ),
        ],
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
          labelText: 'Weight (lbs)',
          border: OutlineInputBorder(),
        ),
        initialValue: widget.dog.weight.toString(),
        onSaved: (String? value) {
          weight = int.parse(value!.trim());
        },
      ),
    );
  }

  Widget _buildAge() {
    final List<DropdownMenuItem<AgeTimespan>> ageTimespanEntries =
        <DropdownMenuItem<AgeTimespan>>[];
    for (final AgeTimespan timespan in AgeTimespan.values) {
      ageTimespanEntries.add(
        DropdownMenuItem<AgeTimespan>(
            value: timespan, child: Text(timespan.name)),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: Row(
        children: [
          Expanded(
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
              initialValue: widget.dog.age.toString(),
              onSaved: (String? value) {
                age = int.parse(value!.trim());
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return 'Please select a value';
                }
                return null;
              },
              hint: const Text('months/years'),
              items: ageTimespanEntries,
              onChanged: (value) => {},
              onSaved: (newValue) {
                ageTimespan = newValue!.getValue();
              },
            ),
          )
        ],
      ),
    );
  }
}
