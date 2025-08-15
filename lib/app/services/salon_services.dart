import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salon_finder/app/data/salon_model.dart';

class SalonServices {
  static CollectionReference salonCollection = FirebaseFirestore.instance
      .collection('salons');
  //generate a unique id for a new salon
  static String generateSalonId() {
    return salonCollection.doc().id;
  }

  static Future<({bool success, String message})> createSalon(
    SalonModel salonData,
  ) async {
    try {
      if(salonData.imageUrl.isNotEmpty){
        var file = File(salonData.imageUrl);
        var uploadUrl = await uploadSalonImageToStorage(file, salonData.id);
        salonData = salonData.copyWith(imageUrl: uploadUrl);
      }
      await salonCollection.doc(salonData.id).set(salonData.toMap());
      return (success: true, message: 'Salon created successfully');
    } catch (e) {
      return (success: false, message: 'Failed to create salon: $e');
    }
  }

  static Future<({bool success, String message})> updateSalon(
    SalonModel salonData,
  ) async {
    try {
      if (salonData.imageUrl.isNotEmpty&&!salonData.imageUrl.contains('http')) {
        var file = File(salonData.imageUrl);
        var uploadUrl = await uploadSalonImageToStorage(file, salonData.id);
        salonData = salonData.copyWith(imageUrl: uploadUrl);
      }
      await salonCollection.doc(salonData.id).update(salonData.toMap());
      return (success: true, message: 'Salon updated successfully');
    } catch (e) {
      return (success: false, message: 'Failed to update salon: $e');
    }
  }

  //stream to get all salons
  static Stream<List<SalonModel>> getAllSalons() {
    return salonCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        return SalonModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Future<List<SalonModel>> getSalonsByOwnerId(String id) async {
    try {
      var querySnapshot = await salonCollection
          .where('salonOwnerId', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs.map((doc) {
        return SalonModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      return [];
    }
  }

    static Future<String> uploadSalonImageToStorage(File image,String salonId) async {
    try {
      // Upload image to Firebase Storage
      String filePath =
          'salons/$salonId/image.jpg';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(filePath)
          .putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }

  static Future<({bool success, String message})> deleteSalon(String id) async {
    try {
      //delete salon image
      String filePath = 'salons/$id/image.jpg';
      await FirebaseStorage.instance.ref(filePath).delete();
      await salonCollection.doc(id).delete();
      return (success: true, message: 'Salon deleted successfully');
    } catch (e) {
      print('Error deleting salon: $e');
      return (success: false, message: 'Failed to delete salon: $e');
    }
  }
}
