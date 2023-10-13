import 'package:flutter/material.dart';

class ErrorHandling extends StatelessWidget {
  const ErrorHandling({super.key});

  static void showError(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
