import 'package:flutter/material.dart';
import 'package:playpal/service/dog_service.dart';

class DeleteDogButton extends StatelessWidget {
  const DeleteDogButton({super.key, required this.dogId});
  final String dogId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => DogService.deleteDog(dogId),
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red)),
      child: const Text('Delete???'),
    );
  }
}
