import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';

class DogService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void createDog(
    UserModel user,
    String name,
    String breed,
    String energyLevel,
    int weight,
    int age,
    String ageTimespan,
  ) {
    DogModel dogToAdd = DogModel(
      name: name,
      breed: breed,
      energyLevel: energyLevel,
      city: user.city,
      state: user.state,
      weight: weight,
      age: age,
      ageTimespan: ageTimespan,
      likes: [],
      ownerId: user.userId,
      dogId: '',
    );
    db.collection('dogs').add(dogToAdd.toFirestore());
  }
}
