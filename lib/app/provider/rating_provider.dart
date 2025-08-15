import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/rating_model.dart';
import '../services/rating_services.dart';

class ReviewModel {
  final List<RatingModel> reviews;
  final double rating;

  ReviewModel({required this.reviews, required this.rating});
  //copyWith
  ReviewModel copyWith({
    List<RatingModel>? reviews,
    double? rating,
  }) {
    return ReviewModel(
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
    );
  }
}

final ratingAverageStreamProvider = StreamProvider.family<ReviewModel, String>((ref, String salonId) async* {
  var data = RatingServices.getAllRatings(salonId);
  await for (var ratings in data) {
    var averageRating = ratings.fold<double>(
      0.0,
      (sum, rating) => sum + rating.rating,
    ) / (ratings.isEmpty ? 1 : ratings.length);
    yield ReviewModel(
      reviews: ratings,
      rating: averageRating,
    );
  }
});
