import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  final String name;
  final String breed;
  final String energyLevel;
  final String city;
  final String state;
  final int weight;
  final String ownerId;

  const Dog({
    required this.name,
    required this.breed,
    required this.energyLevel,
    required this.city,
    required this.state,
    required this.weight,
    required this.ownerId,
  });

  factory Dog.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Dog(
      name: data['f_name'],
      breed: data['breed'],
      energyLevel: data['energy_level'],
      city: data['city'],
      state: data['state'],
      weight: data['weight'],
      ownerId: data['owner_id'],
    );
  }
}
