import 'package:salon_finder/generated/assets.dart';

class CategoryData {
  String name;
  String imageUrl;

  CategoryData({
    required this.name,
    required this.imageUrl,
  });

 static List<CategoryData> get categories => [
        CategoryData(
          name: 'Haircuts',
          imageUrl: Assets.imagesBarber,
        ),
        CategoryData(
          name: 'Nails',
          imageUrl: Assets.imagesNailSalon,
        ),
        CategoryData(
          name: 'Makeup',
          imageUrl: Assets.imagesMakeup,
        ),
        CategoryData(
          name: 'Massage',
          imageUrl: Assets.imagesMassage,
        ),
      ];
}
