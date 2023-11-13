import 'package:flutter/material.dart';
import 'package:playpal/service/dog_service.dart';

class DeleteDogButton extends StatelessWidget {
  const DeleteDogButton({
    super.key,
    required this.dogId,
    required this.userId,
  });
  final String dogId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        DogService.deleteDog(dogId, userId);
        Navigator.pop(context);
      },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red)),
      child: const Text('Delete???'),
    );
  }
}
