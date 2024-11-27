import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/common_image_view.dart';
import '../../../constants/image_constant.dart';
import '../../../customwidgets/buildLocationInputField.dart';
import '../../../customwidgets/buildSlidingUpPanel.dart';
import '../../../routes/app_pages.dart';
import '../../../services/text_style_util.dart';
import '../../directioncard/views/directioncard_view.dart';
import '../../searchview/controllers/searchview_controller.dart';
import '../controllers/savednavgation_controller.dart';

class SavednavgationView extends GetView<SavednavgationController> {
  SavednavgationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              polylines: controller.polylines.toSet(),
              markers: Set<Marker>.of(controller.markers),
              compassEnabled: true,
              trafficEnabled: true,
              buildingsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController mapController) {},
              initialCameraPosition: CameraPosition(
                  target: controller.startPoint.value!, zoom: 13),
            ),
            SlidingUpPanelWidget(
              panelController: controller.panelController,
              minHeight: 100.0,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              panelContentBuilder: (context) => _panelContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panelContent(BuildContext context) {
    return Obx(() =>
            // controller.showLocationOptions.value
            //     ?
            _buildLocationOptions(context)
        // : _buildPlaceDetails(context),
        );
  }

  Widget _buildLocationOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildPanelHandle(),
              buildHeader('Routes', context),
              _buildLocationFields(context),
              Divider(color: context.lightGrey),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SAVEDREALTIMENAVIGATION, arguments: {
                    'polylines': controller.polylineCoordinates,
                    'getSavedRoutes': controller.getSavedRoutes
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${((controller.getSavedRoutes!.value!.data!.results![0]!.distance) * 0.001).toStringAsFixed(2)} km',
                          style: TextStyleUtil.poppins500(
                            fontSize: 18.kh,
                            color: context.brandColor1,
                          ),
                        ),
                        Text(
                          'via {StreetName}',
                          style: TextStyleUtil.poppins400(
                            fontSize: 12.kh,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: context.brandColor1),
                      child: CommonImageView(
                        svgPath: ImageConstant.svgnavigator,
                      ).paddingAll(9.kw),
                    )
                  ],
                ).paddingSymmetric(horizontal: 16.kw),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyleUtil.poppins500(fontSize: 20.kh)),
        IconButton(
          onPressed: () => controller.showLocationOptions.value = false,
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ],
    ).paddingOnly(left: 16.kh, right: 16.kw, top: 18.kh);
  }

  Widget _buildLocationIcons() {
    return Column(
      children: [
        CommonImageView(svgPath: ImageConstant.blueCurrentLocationIcon)
            .paddingOnly(bottom: 8.kh),
        DottedLine(
          direction: Axis.vertical,
          lineLength: 30.kh,
          lineThickness: 2.0,
          dashLength: 7.0,
          dashGapRadius: 7.kw,
          dashColor: Colors.grey,
        ).paddingOnly(bottom: 8.kh),
        CommonImageView(svgPath: ImageConstant.svgBlueLocationIcon),
      ],
    ).paddingOnly(right: 12.kw);
  }

  final FocusNode currentLocationFocusNode = FocusNode();
  final FocusNode destinationLocationFocusNode = FocusNode();

  Widget _buildLocationFields(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationIcons(),
        Expanded(
          child: Column(
            children: [
              buildLocationInputField(
                hintText: controller.sourcePlaceName.value,
                controller: controller.currentLocationController,
                context: context,
                itemClick: (Prediction) {
                  destinationLocationFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(currentLocationFocusNode);
                },
              ),
              16.kheightBox,
              buildLocationInputField(
                hintText: controller.destinationPlaceName.value,
                controller: controller.destinationLocationController,
                context: context,
                itemClick: (Prediction prediction) async {
                  Get.find<SearchviewController>().searchcontroller.text =
                      prediction.description!;
                  // final placeId = prediction.placeId;
                  //
                  // // Fetch place details and store globally
                  // await controller.fetchPlaceDetails(placeId!);
                  // // Access the global placeDetails variable
                  // final placeDetails = controller.placeName;
                  // print('placedetails $placeDetails');
                },
              ),
            ],
          ),
        ),
        _buildActionIcons(),
      ],
    ).paddingOnly(left: 16.kh, right: 16.kw, top: 8.kh, bottom: 8.kh);
  }

  Widget _buildActionIcons() {
    return Column(
      children: [
        const Icon(Icons.more_horiz).paddingOnly(top: 12.kh),
        const Icon(Icons.swap_vert).paddingOnly(top: 42.kh),
      ],
    ).paddingOnly(left: 8.kw);
  }

  // Widget _buildPlaceDetails(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.kw),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         buildPanelHandle(),
  //         SizedBox(height: 16.kh),
  //         _buildPlaceHeader(),
  //         SizedBox(height: 8.kh),
  //         _buildPlaceRating(),
  //         SizedBox(height: 8.kh),
  //         _buildPlaceDistance(),
  //         _buildCountryText(),
  //         SizedBox(height: 16.kh),
  //         _buildPlaceImages(),
  //         SizedBox(height: 18.kh),
  //         _buildActionButtons(context),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildPlaceHeader() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         controller.placeName.value,
  //         style: TextStyle(
  //           fontSize: 24.kh,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           // Handle share action
  //         },
  //         child: const Icon(Icons.share),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildPlaceRating() {
  //   return Row(
  //     children: [
  //       const Icon(Icons.star, color: Colors.amber),
  //       SizedBox(width: 4.kw),
  //       Text(controller.placeRating.value.toString()),
  //       SizedBox(width: 8.kw),
  //       Text('${controller.openNow} • ${controller.closingTime}'),
  //     ],
  //   );
  // }
  //
  // Widget _buildPlaceDistance() {
  //   return Text(
  //       '${controller.getSavedRoutes!.value!.data!.results![0]!.distance}kms');
  // }
  //
  // Widget _buildCountryText() {
  //   return Text(controller.country.toString());
  // }
  //
  // Widget _buildPlaceImages() {
  //   return SizedBox(
  //     height: 120.0,
  //     child: Obx(
  //       () => ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: controller.placeImages.length,
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               Get.to(() => ImageGalleryView(
  //                     images: controller.placeImages,
  //                     initialIndex: index,
  //                   ));
  //             },
  //             child: Padding(
  //               padding: EdgeInsets.only(right: 8.0.kw),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8.0.kw),
  //                 child: Image.network(
  //                   controller.placeImages[index],
  //                   height: 120.0,
  //                   width: 180.0,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildActionButtons(BuildContext context) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CustomButton(
  //           title: 'Get Direction',
  //           color: context.brandColor1,
  //           onTap: () => controller.showLocationOptions.toggle(),
  //         ).paddingOnly(right: 18.kw),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: Border.all(color: context.brandColor1, width: 2.kw),
  //         ),
  //         child: IconButton(
  //           onPressed: () {
  //             // controller.postSaveRoute(
  //             //     points: controller.getroutes.data!.points,
  //             //     type: 'SAVED',
  //             //     placeId: controller.placeID,
  //             //     time: controller.getroutes.data!.time,
  //             //     distance: controller.getroutes.data!.distance,
  //             //     instructions: controller.getroutes.data!.instructions,
  //             //     startName: controller.currentPlaceName.value,
  //             //     endName: controller.placeName.value);
  //           },
  //           icon: Icon(
  //             Icons.bookmark_border_outlined,
  //             color: context.brandColor1,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
