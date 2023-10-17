import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required String uid,
      required String name,
      required String bio,
      required Uint8List file}) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty || bio.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('profileImage', file);
        await _firestore
            .collection('userProfile')
            .doc(uid)
            .set({'name': name, 'biography': bio, 'imageUrl': imageUrl});
        resp = "Success";
      }
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<String> updateData(
      {required String uid,
        required String name,
        required String bio,
        required Uint8List file}) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty || bio.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('profileImage', file);
        await _firestore
            .collection('userProfile')
            .doc(uid)
            .update({'name': name, 'biography': bio, 'imageUrl': imageUrl});
        resp = "Success";
      }
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<String> updateDataWithoutImage(
      {required String uid,
        required String name,
        required String bio}) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty || bio.isNotEmpty) {
        await _firestore
            .collection('userProfile')
            .doc(uid)
            .update({'name': name, 'biography': bio});
        resp = "Success";
      }
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }



}
