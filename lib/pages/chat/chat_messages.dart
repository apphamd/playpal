import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playpal/crud/message_crud.dart';
import 'package:playpal/models/message_model.dart';
import 'package:playpal/models/user_model.dart';
import 'package:playpal/pages/chat/message_bubble.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({
    super.key,
    required this.currentUser,
    required this.recipient,
  });
  final UserModel currentUser;
  final UserModel recipient;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: MessageCrud.getMessages(
            widget.currentUser.userId,
            widget.recipient.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MessageModel> messages = [];
            for (var doc in snapshot.data!.docs) {
              messages.add(MessageModel.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>));
            }

            scrollToBottom();

            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // copies iphone timestamp logic
                    if (index == 0) ...{
                      const SizedBox(height: 18),
                      Text(DateFormat.yMMMd('en_US')
                          .add_jm()
                          .format(messages[index].timestamp.toDate()))
                    } else if ((messages[index].timestamp.seconds -
                            messages[index - 1].timestamp.seconds >=
                        3600)) ...{
                      const SizedBox(height: 18),
                      Text(DateFormat.yMMMd('en_US')
                          .add_jm()
                          .format(messages[index].timestamp.toDate()))
                    } else if ((messages[index].timestamp.seconds -
                            messages[index - 1].timestamp.seconds >=
                        120)) ...{
                      const SizedBox(height: 6)
                    },
                    MessageBubble(
                      message: messages[index],
                      isSender:
                          messages[index].senderId == widget.currentUser.userId
                              ? true
                              : false,
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
}
