import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/profile/edit_user_page.dart';

class EditUserMenuItemButton extends StatelessWidget {
  const EditUserMenuItemButton(
      {super.key, required this.currentUser, required this.updateUser});
  final UserModel currentUser;
  final Function(UserModel updatedUser) updateUser;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      child: const Text('Edit Profile'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditUserPage(
            currentUser: currentUser,
            updateUser: updateUser,
          ),
        ),
      ),
    );
  }
}
