import 'package:flutter/material.dart';
import 'package:playpal/pages/components/card/report_menu_button.dart';
import 'package:playpal/pages/components/profile/user_more_menu_button.dart';
import 'package:playpal/service/message_service.dart';
import 'package:playpal/models/message_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/chat_bar.dart';
import 'package:playpal/pages/chat/chat_messages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.recipient,
    required this.currentUser,
  });
  final UserModel recipient;
  final UserModel currentUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.recipient.firstName} ${widget.recipient.lastName}'),
          actions: [
            MenuAnchor(
              menuChildren: <Widget>[
                ReportMenuButton(
                  reportingUserId: widget.currentUser.userId,
                  reportedUserId: widget.recipient.userId,
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
                    Icons.more_vert,
                    size: 30,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ChatMessages(
                currentUser: widget.currentUser,
                recipient: widget.recipient,
              ),
              ChatBar(
                currentUser: widget.currentUser,
                recipient: widget.recipient,
              ),
            ],
          ),
        ));
  }
}
