import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/error/error_handling.dart';
import 'package:playpal/pages/auth_page.dart';
import 'package:playpal/pages/nav_frame.dart';

class RegisterAdditionalPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const RegisterAdditionalPage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});

  @override
  State<RegisterAdditionalPage> createState() => _RegisterAdditionalPageState();
}

class _RegisterAdditionalPageState extends State<RegisterAdditionalPage> {
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

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
        email: widget.email,
        password: widget.password,
      );
      Navigator.pop(context);
      addUserDetails(
          credential.user!.uid,
          widget.firstName.trim(),
          widget.lastName.trim(),
          cityController.text.trim(),
          stateController.text.trim());
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ErrorHandling.showError(context, e.code);
    }
  }

  Future addUserDetails(String userId, String firstName, String lastName,
      String city, String state) async {
    await db.collection('users').doc(userId).set({
      'f_name': firstName,
      'l_name': lastName,
      'city': city,
      'state': state,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets_rounded,
                    size: 80,
                    color: Colors.amber[200],
                  ),

                  const SizedBox(height: 35),

                  // hello again!
                  const Text(
                    'Tell us a little more about yourself!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // first name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.blue.shade50),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: TextField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'City',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.blue.shade50),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: TextField(
                          controller: stateController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'State',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  'Go back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: InkWell(
                          onTap: () {
                            userRegister();
                          },
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  'Let\'s Pawty!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
