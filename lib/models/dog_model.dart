import 'package:cloud_firestore/cloud_firestore.dart';

class DogModel {
  final String name;
  final String breed;
  final String energyLevel;
  final String city;
  final String state;
  final int weight;
  final List? likes;
  final String ownerId;
  final String dogId;

  const DogModel({
    required this.name,
    required this.breed,
    required this.energyLevel,
    required this.city,
    required this.state,
    required this.weight,
    required this.likes,
    required this.ownerId,
    required this.dogId,
  });

  factory DogModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return DogModel(
      name: data['f_name'],
      breed: data['breed'],
      energyLevel: data['energy_level'],
      city: data['city'],
      state: data['state'],
      weight: data['weight'],
      likes: data['likes'],
      ownerId: data['owner_id'],
      dogId: snapshot.id,
    );
  }
}
