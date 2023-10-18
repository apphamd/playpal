import 'package:flutter/material.dart';

class HorizontalMockCard extends StatelessWidget {
  const HorizontalMockCard({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
    );
  }
}
