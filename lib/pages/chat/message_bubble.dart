import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playpal/models/message_model.dart';
import 'package:intl/date_symbol_data_local.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
  });
  final MessageModel message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: isSender
            ? BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              )
            : BoxDecoration(
                color: Colors.amber[800],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
        margin: const EdgeInsets.only(
          top: 3,
        ),
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // the actual message
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  message.content,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ]),
      ),
    );
  }
}
