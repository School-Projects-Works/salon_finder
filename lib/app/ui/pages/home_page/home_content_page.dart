import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/rating_model.dart';
import 'package:salon_finder/app/provider/rating_provider.dart';
import 'package:salon_finder/app/provider/salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/salon_item.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';
import 'package:salon_finder/generated/assets.dart';
import '../../../data/category_data.dart';
import '../../../provider/current_user_provider.dart';
import 'salon_list_page.dart';

class HomeContentPage extends ConsumerStatefulWidget {
  const HomeContentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeContentPageState();
}

class _HomeContentPageState extends ConsumerState<HomeContentPage> {
  FocusNode searchFocusNode = FocusNode();

  //check if searchFocusNode is focused
  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  //check on focused

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(currentUserProvider).user;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.deepPurpleAccent.shade100.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hey there!, ${user?.name ?? 'Guest'}",
                  style: AppTextStyles.subtitle1(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      (user?.profilePictureUrl != null &&
                          user!.profilePictureUrl.isNotEmpty)
                      ? NetworkImage(user.profilePictureUrl)
                      : const AssetImage(
                              Assets.imagesUser,
                            ) // Fallback to a default image
                            as ImageProvider,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          //Search bar for salons
          if (ref.watch(selectedFilterProvider).isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: searchFocusNode,
                      //on focus change
                      onChanged: (value) {
                        ref.read(salonProvider.notifier).filterSalons(value);
                      },
                      onTap: () {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for salons...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        suffix: searchFocusNode.hasFocus
                            ? InkWell(
                                child: Icon(Icons.close),
                                onTap: () {
                                  setState(() {
                                    searchFocusNode.unfocus();
                                  });
                                },
                              )
                            : null,
                        fillColor: Colors.black.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  if (!searchFocusNode.hasFocus) const SizedBox(width: 8),
                  if (!searchFocusNode.hasFocus)
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        // Handle filter logic here
                      },
                    ),
                ],
              ),
            ),
          if (ref.watch(selectedFilterProvider).isEmpty)
            const SizedBox(height: 16),
          if (ref.watch(selectedFilterProvider).isEmpty)
            if (searchFocusNode.hasFocus)
              Expanded(child: SalonListPage())
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // List of categories (e.g., Hair, Nails, Spa)
                          Text(
                            "Top Categories",
                            style: AppTextStyles.subtitle1(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              //center the list of categories
                              physics: const BouncingScrollPhysics(),
                              itemCount: CategoryData.categories.length,
                              itemBuilder: (context, index) {
                                final category = CategoryData.categories[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(salonProvider.notifier)
                                          .filterSalons(category.name);
                                      ref
                                          .read(selectedFilterProvider.notifier)
                                          .state = category
                                          .name;
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              category.imageUrl,
                                              fit: BoxFit.cover,
                                              width: 35,
                                              height: 35,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          category.name,
                                          style: AppTextStyles.body(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // salons near user
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Salons Near You",
                                style: AppTextStyles.subtitle1(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              //view all
                              TextButton(
                                onPressed: () {
                                  // Handle view all action
                                },
                                child: Text(
                                  "View All",
                                  style: AppTextStyles.body(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // all salons section with a grid view
                          SizedBox(
                            height: 200,
                            child: ref
                                .watch(salonsNearYouProvider)
                                .when(
                                  loading: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  error: (error, stack) {
                                    return Center(
                                      child: Text(
                                        'Error: $error',
                                        style: AppTextStyles.body(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                  data: (salons) {
                                    if (salons.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No salons found near you",
                                          style: AppTextStyles.body(
                                            color: AppColors.textMuted,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //center the list of categories
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: salons.length,
                                      itemBuilder: (context, index) {
                                        final salon = salons[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                          child: SalonItem(salon: salon),
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),

                          //const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Rated Salons",
                                style: AppTextStyles.subtitle1(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              //view all
                            ],
                          ),
                          // all salons section with a grid view
                          SizedBox(
                            height: 200,
                            child: ref
                                .watch(topRatedSalonsProvider)
                                .when(
                                  loading: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  error: (error, stack) {
                                    return Center(
                                      child: Text(
                                        'Error: $error',
                                        style: AppTextStyles.body(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                  data: (salons) {
                                    if (salons.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No salons found near you",
                                          style: AppTextStyles.body(
                                            color: AppColors.textMuted,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //center the list of categories
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: salons.length,
                                      itemBuilder: (context, index) {
                                        final salon = salons[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                          child: SalonItem(salon: salon),
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          if (ref.watch(selectedFilterProvider).isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Showing salons filtered by: ${ref.watch(selectedFilterProvider)}",
                      style: AppTextStyles.subtitle1(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref.read(selectedFilterProvider.notifier).state = '';
                    },
                  ),
                ],
              ),
            ),
          if (ref.watch(selectedFilterProvider).isNotEmpty)
            Expanded(child: const SalonListPage()),
        ],
      ),
    );
  }
}
