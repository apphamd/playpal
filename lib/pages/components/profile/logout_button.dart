import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    super.key,
    required this.userSignOut,
  });
  final void Function() userSignOut;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.userSignOut();
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
    );
  }
}
