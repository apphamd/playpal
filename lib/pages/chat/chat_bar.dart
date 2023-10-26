import 'package:flutter/material.dart';
import 'package:playpal/crud/message_crud.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/chat_text_form_field.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({
    super.key,
    required this.currentUser,
    required this.recipient,
  });
  final UserModel currentUser;
  final UserModel recipient;

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        // margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                child: ChatTextFormField(
                  controller: controller,
                  hintText: 'Message',
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendMessage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await MessageCrud.createMessage(
        content: controller.text,
        senderId: widget.currentUser.userId,
        recipientId: widget.recipient.userId,
      );
      controller.clear();
      if (context.mounted) FocusScope.of(context).unfocus();
    }
    if (context.mounted) FocusScope.of(context).unfocus();
  }
}
