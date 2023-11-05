import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }

    print('No images selected!');
  }

  static Future<String> uploadImageToStorage(
    String imageName,
    String id,
    Uint8List file,
  ) async {
    Reference ref = _storage.ref().child(id).child(imageName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> saveUserProfilePicData({
    required String userId,
    required Uint8List file,
  }) async {
    String resp = " Some Error Occurred";
    try {
      print('Uploading image!');
      String imageUrl =
          await uploadImageToStorage('ProfileImage', userId, file);
      print(imageUrl);
      await _firestore
          .collection('users')
          .doc(userId)
          .set({'profile_pic': imageUrl}, SetOptions(merge: true));
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  static Future<String> saveDogProfilePicData({
    required String dogId,
    required Uint8List file,
  }) async {
    String resp = " Some Error Occurred";
    try {
      print('Uploading image!');
      String imageUrl = await uploadImageToStorage('ProfileImage', dogId, file);
      print(imageUrl);
      await _firestore
          .collection('dogs')
          .doc(dogId)
          .set({'profile_pic': imageUrl}, SetOptions(merge: true));
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
}
