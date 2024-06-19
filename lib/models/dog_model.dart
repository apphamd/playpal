import 'package:cloud_firestore/cloud_firestore.dart';

class DogModel {
  final String name;
  final String gender;
  final String breed;
  final String energyLevel;
  final String city;
  final String state;
  final int weight;
  final int age;
  final String? ageTimespan;
  final List likes;
  final bool vaccinated;
  final bool fixed;
  final String ownerId;
  final String dogId;

  const DogModel({
    required this.name,
    required this.gender,
    required this.breed,
    required this.energyLevel,
    required this.city,
    required this.state,
    required this.weight,
    required this.age,
    required this.ageTimespan,
    required this.likes,
    required this.vaccinated,
    required this.fixed,
    required this.ownerId,
    required this.dogId,
  });

  factory DogModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return DogModel(
      name: data['f_name'],
      gender: data['gender'],
      breed: data['breed'],
      energyLevel: data['energy_level'],
      city: data['city'],
      state: data['state'],
      weight: data['weight'],
      age: data['age'],
      vaccinated: data['vaccinated'],
      fixed: data['fixed'],
      ageTimespan: data['ageTimespan'],
      likes: data['likes'] ?? [],
      ownerId: data['owner_id'],
      dogId: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "f_name": name,
      "gender": gender,
      "breed": breed,
      "city": city,
      "state": state,
      "energy_level": energyLevel,
      "weight": weight,
      "age": age,
      "ageTimespan": ageTimespan,
      "vaccinated": vaccinated,
      "fixed": fixed,
      "likes": likes,
      "owner_id": ownerId,
    };
  }
}

enum AgeTimespan {
  month('month(s)'),
  year('year(s)');

  const AgeTimespan(this.value);
  final String value;
  String getValue() => value;
  String getName() => name;
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

enum Gender {
  male,
  female;

  String getValue() => name;
}
