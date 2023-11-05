import 'package:flutter/material.dart';

class ErrorHandling {
  const ErrorHandling();

  static void showError(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
      ),
    );
  }
}
