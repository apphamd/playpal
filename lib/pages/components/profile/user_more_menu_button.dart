import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/profile/edit_user_page.dart';

class UserMenuMoreButton extends StatefulWidget {
  const UserMenuMoreButton({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<UserMenuMoreButton> createState() => _UserMenuMoreButtonState();
}

class _UserMenuMoreButtonState extends State<UserMenuMoreButton> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          child: const Text('Edit Profile'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditUserPage(currentUser: widget.currentUser),
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Icons.settings_outlined,
            size: 30,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
