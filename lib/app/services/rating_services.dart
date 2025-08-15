import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/rating_model.dart';

class RatingServices {
  static CollectionReference ratingCollection = FirebaseFirestore.instance
      .collection('ratings');

  static String generateDocId() {
    return ratingCollection.doc().id;
  }

  //create rating
  static Future<({bool success, String message})> createRating(
    RatingModel rating,
  ) async {
    try {
      await ratingCollection.doc(rating.id).set(rating.toMap());
      return (success: true, message: 'Rating created successfully');
    } catch (e) {
      return (success: false, message: 'Error creating rating');
    }
  }

  //update rating
  static Future<(bool success, String message)> updateRating(
    RatingModel rating,
  ) async {
    try {
      await ratingCollection.doc(rating.id).update(rating.toMap());
      return (true, 'Rating updated successfully');
    } catch (e) {
      return (false, 'Error updating rating');
    }
  }

  //stream to get all ratings
  static Stream<List<RatingModel>> getAllRatings(String salonId) {
    return ratingCollection
        .where('salonId', isEqualTo: salonId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RatingModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  static Future<double> getAverageRating(String id) async {
    var ratings = await ratingCollection.where('salonId', isEqualTo: id).get();
    if (ratings.docs.isEmpty) return 0.0;
    var total = ratings.docs.fold(0.0, (sum, doc) {
      var data = doc.data() as Map<String, dynamic>;
      return sum + (data['rating'] ?? 0);
    });
    return total / ratings.docs.length;
  }
}
