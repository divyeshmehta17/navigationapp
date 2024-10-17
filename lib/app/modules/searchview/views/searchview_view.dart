import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart'
    as google_places;
import 'package:google_places_flutter/model/prediction.dart'
    as google_places_prediction;
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/RecentLocationData.dart';
import '../../../constants/image_constant.dart';
import '../../../customwidgets/addplacebutton.dart';
import '../../../customwidgets/savedLocationCard.dart';
import '../../explore/controllers/explore_controller.dart';
import '../controllers/searchview_controller.dart';

class SearchviewView extends GetView<SearchviewController> {
  const SearchviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exploreController = Get.find<ExploreController>();
    final searchController = Get.find<SearchviewController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              google_places.GooglePlaceAutoCompleteTextField(
                textEditingController: searchController.searchcontroller,
                googleAPIKey:
                    'AIzaSyBO4WzyVucman3AU5D51ox2PP7cpn3FPzY', // Replace with your API key
                inputDecoration: const InputDecoration(
                  hintText: 'Enter your destination..',
                  border: OutlineInputBorder(),
                ),

                itemClick:
                    (google_places_prediction.Prediction prediction) async {
                  searchController.searchcontroller.text =
                      prediction.description!;
                  final placeId = prediction.placeId;
                  if (placeId != null) {
                    // Fetch place details and store globally
                    await searchController.fetchPlaceDetails(placeId);
                    // Access the global placeDetails variable
                    final placeDetails = searchController.placeDetails;
                    if (placeDetails != null) {
                      // Print or use details as needed
                      print('Place Name: ${placeDetails.name}');
                      print('Place Rating: ${placeDetails.rating}');
                      print(
                          'Is Open Now: ${placeDetails.openingHours?.openNow}');

                      // Get polylines and navigate to direction card
                      searchController.getPolylines();
                      // Optionally, add to recent searches
                      searchController.addRecentSearch(RecentLocationData(
                        name: prediction.description!,
                        description: placeDetails.formattedAddress,
                      ));
                    }
                  }

                  searchController.searchcontroller.selection =
                      TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length),
                  );
                },
              ),
              controller.savedLocations.value == null
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 100.kh,
                      child: ListView.builder(
                        itemCount: controller
                                .savedLocations.value!.data!.results!.length +
                            1, // 9 items + 1 for the "Add" button
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          // Check if this is the last item in the list
                          if (index ==
                              controller.savedLocations.value!.data!.results!
                                  .length) {
                            // Return the "Add" button at the end
                            return AddButton();
                          } else {
                            // Return the saved location cards
                            return savedLocationCard(
                                svgPath: ImageConstant.svghomeIcon,
                                name: controller.savedLocations!.value!.data!
                                    .results![index]!.title);
                          }
                        },
                      ),
                    ).paddingOnly(top: 18.kh, left: 18.kw, right: 18.kw),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent'),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
              Obx(
                () => ListView.builder(
                  itemCount: searchController.recentSearches.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final recentSearch = searchController.recentSearches[index];
                    return Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recentSearch.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(recentSearch.description ?? ''),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
