import 'package:cloud_firestore/cloud_firestore.dart';

class DogModel {
  final String name;
  final String breed;
  final String energyLevel;
  final String city;
  final String state;
  final int weight;
  final int? age;
  final String? ageTimespan;
  final List? likes;
  // TODO: add vaccination status
  // final bool isVaccinated;
  final String ownerId;
  final String dogId;

  const DogModel({
    required this.name,
    required this.breed,
    required this.energyLevel,
    required this.city,
    required this.state,
    required this.weight,
    required this.age,
    required this.ageTimespan,
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
      age: data['age'],
      ageTimespan: data['ageTimespan'],
      likes: data['likes'],
      ownerId: data['owner_id'],
      dogId: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "f_name": name,
      "breed": breed,
      "city": city,
      "state": state,
      "energy_level": energyLevel,
      "weight": weight,
      "age": age,
      "ageTimespan": ageTimespan,
      "owner_id": ownerId,
    };
  }
}

enum AgeTimespan {
  month,
  months,
  year,
  years;

  String getValue() => name;
}

enum EnergyLevel {
  high('high', 3),
  medium('medium', 2),
  low('low', 1),
  all('all', 0);

  const EnergyLevel(this.level, this.value);
  final String level;
  final int value;
  String getLevel() => level;
}
