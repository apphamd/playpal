import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/components/profile/delete_user_menu_button.dart';
import 'package:playpal/pages/components/profile/edit_user_menu_button.dart';

class UserMenuMoreButton extends StatefulWidget {
  const UserMenuMoreButton({
    super.key,
    required this.currentUser,
    required this.updateUser,
  });
  final UserModel currentUser;
  final Function(UserModel updatedUser) updateUser;

  @override
  State<UserMenuMoreButton> createState() => _UserMenuMoreButtonState();
}

class _UserMenuMoreButtonState extends State<UserMenuMoreButton> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: <Widget>[
        // Edit Profile
        EditUserMenuItemButton(
          currentUser: widget.currentUser,
          updateUser: widget.updateUser,
        ),

        // Delete User
        DeleteUserMenuItemButton(
          currentUser: widget.currentUser,
          context: context,
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
