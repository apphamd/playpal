import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/service/user_service.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormState> _editUserFormKey = GlobalKey<FormState>();

  // user fields
  String firstName = '';
  String lastName = '';
  String city = '';
  String state = '';
  DateTime birthday = DateTime.now();

  void submitForm() {
    if (context.mounted) FocusScope.of(context).unfocus();
    _editUserFormKey.currentState!.save();
    print('$firstName $lastName $city $state $birthday');
    UserService.updateUser(
      widget.currentUser,
      firstName,
      lastName,
      city,
      state,
      birthday,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.currentUser.firstName}')),
      body: Form(
        key: _editUserFormKey,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                child: _buildFirstName(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 90),
                child: _buildLastName(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 180),
                child: _buildCity(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 270),
                child: _buildState(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 360),
                child: _buildBirthday(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 150),
                child: ElevatedButton(
                  child: const Text('Update Profile'),
                  onPressed: () {
                    if (_editUserFormKey.currentState!.validate()) {
                      submitForm();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstName() {
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
        initialValue: widget.currentUser.firstName,
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
          firstName = value!;
        },
      ),
    );
  }

  Widget _buildLastName() {
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
        initialValue: widget.currentUser.lastName,
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
          lastName = value!;
        },
      ),
    );
  }

  Widget _buildCity() {
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
        initialValue: widget.currentUser.city,
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
          city = value!;
        },
      ),
    );
  }

  Widget _buildState() {
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
        initialValue: widget.currentUser.state,
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
          state = value!;
        },
      ),
    );
  }

  Widget _buildBirthday() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: InputDatePickerFormField(
        fieldLabelText: 'Birth Date',
        initialDate: widget.currentUser.birthday,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onDateSaved: (value) {
          setState(() {
            birthday = value;
          });
        },
      ),
    );
  }
}
