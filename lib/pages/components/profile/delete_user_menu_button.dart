import 'package:flutter/material.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/service/user_service.dart';

class DeleteUserMenuItemButton extends StatefulWidget {
  const DeleteUserMenuItemButton({
    super.key,
    required this.currentUser,
    required this.context,
  });
  final UserModel currentUser;
  final BuildContext context;

  @override
  State<DeleteUserMenuItemButton> createState() =>
      _DeleteUserMenuItemButtonState();
}

class _DeleteUserMenuItemButtonState extends State<DeleteUserMenuItemButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      child: const Text('Delete User'),
      onPressed: () {
        showDialog(
          context: widget.context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('We\'d be sad to see you go :('),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    UserService.deleteUser(widget.currentUser);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        // UserService.deleteUser(currentUser);
      },
    );
  }
}
