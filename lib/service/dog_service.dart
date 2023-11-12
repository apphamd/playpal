import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:playpal/models/dog_model.dart';
import 'package:playpal/models/user_model.dart';

class DogService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

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
    _db.collection('dogs').add(dogToAdd.toFirestore());
  }

  void updateDog(
    String dogId,
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
      dogId: dogId,
    );
    _db.collection('dogs').doc(dogId).set(dogToAdd.toFirestore());
  }

  static deleteDog(String dogId) async {
    _db.runTransaction((transaction) async =>
        transaction.delete(_db.collection('dogs').doc(dogId)));
  }
}
