import 'package:flutter/material.dart';
import 'package:playpal/service/message_service.dart';

class DeleteMatchButton extends StatelessWidget {
  const DeleteMatchButton({
    super.key,
    required this.currentUserId,
    required this.recipientId,
  });
  final String currentUserId;
  final String recipientId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        MessageService.deleteMatch(currentUserId, recipientId);
      },
      icon: const Icon(Icons.delete),
    );
  }
}
