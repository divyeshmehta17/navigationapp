import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart'
    as google_places;
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../constants/image_constant.dart';
import '../../../customwidgets/addplacebutton.dart';
import '../../../customwidgets/savedLocationCard.dart';
import '../controllers/searchview_controller.dart';

class SearchviewView extends GetView<SearchviewController> {
  const SearchviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchviewController>();

    return Scaffold(
      body: Obx(
        () => GestureDetector(
          onTap: () {
            // Hide the suggestions list when tapped outside
            searchController.searchSuggestions.clear();
          },
          child: SafeArea(
            child: Stack(
              children: [
                // Main Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Field
                      google_places.GooglePlaceAutoCompleteTextField(
                        isCrossBtnShown: true,
                        textEditingController:
                            searchController.searchcontroller,
                        isLatLngRequired: false,
                        googleAPIKey: 'AIzaSyBO4WzyVucman3AU5D51ox2PP7cpn3FPzY',
                        boxDecoration: BoxDecoration(
                            color: context.neutralGrey,
                            borderRadius: BorderRadius.circular(12.kw)),
                        inputDecoration: InputDecoration(
                          hintText: 'Enter your destination..',
                          hintStyle: TextStyleUtil.poppins400(
                              fontSize: 14.kh, color: context.darkGrey),
                          prefixIcon: IconButton(
                            icon: Icon(
                              CupertinoIcons.back,
                              color: context.darkGrey,
                              size: 20.kh,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          suffixIcon: Obx(
                            () => IconButton(
                              icon: Icon(
                                searchController.isListening.value
                                    ? CupertinoIcons.mic_fill
                                    : CupertinoIcons.mic,
                                color: context.darkGrey,
                              ),
                              onPressed: () {
                                if (searchController.isListening.value) {
                                  searchController.stopListening();
                                } else {
                                  searchController.startListening();
                                }
                              },
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.kw),
                            borderSide: BorderSide(color: context.neutralGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.kw),
                            borderSide: BorderSide(color: context.neutralGrey),
                          ),
                          filled: true,
                          fillColor: context.neutralGrey,
                        ),
                        itemClick: (prediction) async {
                          searchController.searchcontroller.text =
                              prediction.description!;
                          await searchController
                              .fetchPlaceDetails(prediction.placeId!);

                          searchController.searchcontroller.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: prediction.description!.length),
                          );
                        },
                      ),
                      SizedBox(height: 20.kh),

                      // Saved Locations
                      Text(
                        'Saved Locations',
                        style: TextStyleUtil.poppins600(
                            fontSize: 16.kh, color: Colors.black),
                      ),
                      SizedBox(height: 10.kh),
                      if (controller.savedLocations.value == null)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          height: 100.kh,
                          child: ListView.builder(
                            itemCount: controller.savedLocations.value!.data!
                                    .results!.length +
                                1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index ==
                                  controller.savedLocations.value!.data!
                                      .results!.length) {
                                return const AddButton();
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    controller.fetchSavedPlaceDetails(
                                        destinationlatitude: controller
                                            .savedLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .location!
                                            .coordinates![0]!
                                            .toString(),
                                        destinationlongitude: controller
                                            .savedLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .location!
                                            .coordinates![1]!
                                            .toString(),
                                        placeId: controller
                                            .savedLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .placeId
                                            .toString());
                                  },
                                  child: savedLocationCard(
                                    svgPath: ImageConstant.svghomeIcon,
                                    name: controller.savedLocations.value!.data!
                                        .results![index]!.title,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      SizedBox(height: 20.kh),

                      // Recent Searches
                      Text(
                        'Recent',
                        style: TextStyleUtil.poppins600(
                            fontSize: 16.kh, color: Colors.black),
                      ),
                      controller.searchLocations.value == null
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: controller
                                  .searchLocations.value!.data!.results!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.fetchPlaceDetailsRecent(
                                        destinationlatitude: controller
                                            .searchLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .location!
                                            .coordinates![0]!
                                            .toString(),
                                        destinationlongitude: controller
                                            .searchLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .location!
                                            .coordinates![1]!
                                            .toString(),
                                        placeId: controller
                                            .searchLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .placeId
                                            .toString());
                                  },
                                  child: Row(children: [
                                    const Icon(Icons.history)
                                        .paddingOnly(right: 18.kw),
                                    Expanded(
                                      child: Text(
                                        controller
                                            .searchLocations
                                            .value!
                                            .data!
                                            .results![index]!
                                            .location!
                                            .addressLine!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleUtil.poppins400(
                                            fontSize: 14.kh),
                                      ),
                                    ),
                                  ]).paddingOnly(top: 18.kh),
                                );
                              },
                            ),
                    ],
                  ).paddingOnly(left: 18.kw, right: 18.kw),
                ),

                // Suggestions Overlay
                if (searchController.searchSuggestions.isNotEmpty)
                  Positioned(
                    top: 80
                        .kh, // Adjust the position to fit below the search bar
                    left: 18.kw,
                    right: 18.kw,
                    child: Container(
                      height: 200.kh,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.kw),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: searchController.searchSuggestions.length,
                        padding: EdgeInsets.symmetric(vertical: 8.kh),
                        itemBuilder: (context, index) {
                          final prediction =
                              searchController.searchSuggestions[index];
                          return ListTile(
                            title: Text(
                              prediction.description ?? "",
                              style: TextStyleUtil.poppins400(fontSize: 14.kh),
                            ),
                            onTap: () async {
                              searchController.searchcontroller.text =
                                  prediction.description!;
                              final placeId = prediction.placeId;
                              if (placeId != null) {
                                await searchController
                                    .fetchPlaceDetails(placeId);
                                searchController.getPolylines();
                              }
                              searchController.searchSuggestions.clear();
                            },
                          );
                        },
                      ),
                    ),
                  ),

                // Listening Overlay

                if (searchController.isListening.value == true)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20.kh),
                        Text(
                          'Listening...',
                          style: TextStyleUtil.poppins600(
                              fontSize: 18.kh, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ).paddingOnly(top: 18.kh),
          ),
        ),
      ),
    );
  }
}
