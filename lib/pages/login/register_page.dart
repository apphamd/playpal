import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/error/error_handling.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // form keys
  final _nameFormKey = GlobalKey<FormState>();
  final _bDayFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _emailPasswordFormKey = GlobalKey<FormState>();

  // password controller
  final _passwordController = TextEditingController();

  // fields for user to register
  String _fName = '';
  String _lName = '';
  DateTime _birthdate = DateTime.now();
  String _city = '';
  String _state = '';
  String _email = '';
  String _password = '';
  int currentStep = 0;

  Future userRegister() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pop(context);
      addUserDetails(credential.user!.uid, _fName.trim(), _lName.trim(),
          _city.trim(), _state.trim(), Timestamp.fromDate(_birthdate));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ErrorHandling.showError(context, e.code);
    }
  }

  Future addUserDetails(
    String userId,
    String firstName,
    String lastName,
    String city,
    String state,
    Timestamp birthdate,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'f_name': firstName,
      'l_name': lastName,
      'city': city,
      'state': state,
      'birthday': birthdate,
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<FormState>> _formKeyList = [
      _nameFormKey,
      _bDayFormKey,
      _locationFormKey,
      _emailPasswordFormKey,
    ];
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 30.0),
                child: const Text('Register', style: TextStyle(fontSize: 40))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Stepper(
              connectorThickness: 2.75,
              connectorColor: MaterialStatePropertyAll(Colors.amber.shade600),
              physics: const NeverScrollableScrollPhysics(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: currentStep == getSteps().length - 1
                          ? const Text('SUBMIT')
                          : const Text('NEXT'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: currentStep == 0
                          ? const Text('CANCEL')
                          : const Text('BACK'),
                    ),
                  ],
                );
              },
              type: StepperType.vertical,
              steps: getSteps(),
              currentStep: currentStep,
              onStepTapped: (value) {
                setState(() {
                  currentStep = value;
                });
              },
              onStepContinue: () {
                if (currentStep != getSteps().length - 1 &&
                    _formKeyList[currentStep].currentState!.validate()) {
                  _formKeyList[currentStep].currentState!.save();
                  setState(() {
                    currentStep++;
                  });
                } else if (currentStep == getSteps().length - 1 &&
                    _formKeyList[currentStep].currentState!.validate()) {
                  _formKeyList[currentStep].currentState!.save();
                  print(
                      '$_fName $_lName \n${_birthdate} \n$_city, $_state \n$_email $_password');
                  userRegister();
                  Navigator.pop(context);
                }
              },
              onStepCancel: () {
                if (currentStep != 0) {
                  setState(() {
                    currentStep--;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),

          // have an account already?
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Have an account already?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sign in!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[600],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text('Name'),
          content: Form(
            key: _nameFormKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                // first name
                _buildFName(),

                const SizedBox(height: 10),

                // last name
                _buildLName(),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text('Date of Birth'),
          content: Form(
            key: _bDayFormKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildBirthdate(),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('Location'),
          content: Form(
            key: _locationFormKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildCity(),
                const SizedBox(height: 10),
                _buildState(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 3,
          title: Text('Email & Password'),
          content: Form(
            key: _emailPasswordFormKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildEmail(),
                const SizedBox(height: 10),
                _buildPassword(),
                const SizedBox(height: 10),
                _buildPasswordConfirmation(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ];

  Widget _buildFName() {
    return TextFormField(
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
        labelText: 'First Name',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _fName = value!;
      },
    );
  }

  Widget _buildLName() {
    return TextFormField(
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
        labelText: 'Last Name',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _lName = value!;
      },
    );
  }

  Widget _buildCity() {
    return TextFormField(
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid city';
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
        labelText: 'City',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _city = value!;
      },
    );
  }

  Widget _buildState() {
    return TextFormField(
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid city';
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
        labelText: 'State',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _state = value!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
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
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _email = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: _passwordController,
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
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      onSaved: (String? value) {
        _password = value!;
      },
    );
  }

  Widget _buildPasswordConfirmation() {
    return TextFormField(
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        } else if (value == null || value.isEmpty) {
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
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBirthdate() {
    return InputDatePickerFormField(
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onDateSaved: (value) {
        setState(() {
          _birthdate = value;
        });
      },
    );
  }
}
