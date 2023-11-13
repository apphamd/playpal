import 'package:flutter/material.dart';

class NoDogs extends StatelessWidget {
  const NoDogs({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(
      children: [
        Text('You have no dogs. Add a dog to see others!'),
      ],
    ));
  }
}
