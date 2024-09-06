import 'package:flutter/material.dart';

class AdminConsolePage extends StatefulWidget {
  const AdminConsolePage({super.key});

  @override
  State<AdminConsolePage> createState() => AdminConsolePageState();
}

class AdminConsolePageState extends State<AdminConsolePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          Text('Hello world!'),
        ],
      ),
    );
  }
}
