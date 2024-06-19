import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playpal/pages/profile/required_image_page.dart';
import 'package:playpal/service/dog_service.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/service/form_service.dart';

class AddDogPage extends StatefulWidget {
  AddDogPage({
    super.key,
    required this.user,
    required this.addDog,
  });
  final UserModel user;
  final Function(String dogId) addDog;

  @override
  State<AddDogPage> createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  final GlobalKey<FormState> _addDogFormKey = GlobalKey<FormState>();
  final DogService dogService = DogService();

  // dog fields
  String _dogName = '';
  String _breed = '';
  String _energyLevel = '';
  String _gender = '';
  int _weight = 0;
  int _age = 0;
  String _ageTimespan = '';
  bool _vaccinated = false;
  bool _fixed = false;

  void toUploadImagePage() async {
    if (context.mounted) FocusScope.of(context).unfocus();
    _addDogFormKey.currentState!.save();
    FormState? formState = _addDogFormKey.currentState;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequiredImagePage(
          addDogFormState: formState,
          submitForm: submitForm,
        ),
      ),
    );
  }

  Future<String> submitForm() async {
    print('$_dogName $_breed $_energyLevel $_weight $_age $_ageTimespan');
    String dogId = await dogService.createDog(
      widget.user,
      _dogName,
      _gender,
      _breed,
      _energyLevel,
      _weight,
      _age,
      _ageTimespan,
      _vaccinated,
      _fixed,
    );
    widget.addDog(dogId);
    return dogId;
  }

  void monthsToYearsConversion() {
    if (_age > 12 && _ageTimespan == 'month') {
      _age = _age ~/ 12;
      _ageTimespan = AgeTimespan.year.getName();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _buildWeight()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildGender()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 360),
                child: _buildAge(),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 460),
                child: _buildVaccinated(),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 530),
                child: _buildFixed(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  child: const Text('Next Page!'),
                  onPressed: () {
                    if (_addDogFormKey.currentState!.validate()) {
                      toUploadImagePage();
                    }
                  },
                ),
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
          _dogName = value!;
        },
      ),
    );
  }

  Widget _buildGender() {
    final List<DropdownMenuItem<Gender>> genderEntries =
        <DropdownMenuItem<Gender>>[];
    for (final Gender gender in Gender.values) {
      if (gender.name != 'all') {
        genderEntries.add(
          DropdownMenuItem<Gender>(value: gender, child: Text(gender.name)),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.only(right: 40.0, top: 20, bottom: 20),
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please select a value';
          }
          return null;
        },
        hint: const Text('Gender'),
        items: genderEntries,
        onChanged: (value) => {},
        onSaved: (newValue) {
          _gender = newValue!.getValue();
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
          _breed = value!;
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
              _energyLevel = newValue!.getLevel();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeight() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 20, bottom: 20),
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
        onSaved: (String? value) {
          _weight = int.parse(value!.trim());
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
            value: timespan, child: Text(timespan.getValue())),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLength: 2,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number 0-99';
                }
                if (FormService.alphabetRegEx.hasMatch(value)) {
                  return 'You can only enter numbers.';
                }
                monthsToYearsConversion();
                return null;
              },
              decoration: const InputDecoration(
                counterText: '',
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
                int age = int.parse(value!.trim());
                setState(() {
                  _age = age;
                });
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
              onChanged: (value) => {
                if (value != null) {_ageTimespan = value.getName()}
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  _ageTimespan = newValue.getName();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVaccinated() {
    return SizedBox(
      width: 200,
      child: Card(
        child: CheckboxListTile(
          value: _vaccinated,
          onChanged: (value) {
            setState(() {
              _vaccinated = value!;
            });
            print(_vaccinated);
          },
          title: const Text('Vaccinated?'),
        ),
      ),
    );
  }

  Widget _buildFixed() {
    return SizedBox(
      width: 200,
      child: Card(
        child: CheckboxListTile(
          value: _fixed,
          onChanged: (value) {
            setState(() {
              _fixed = value!;
            });
            print(_fixed);
          },
          title: const Text('Neutered / Spayed?'),
        ),
      ),
    );
  }
}
