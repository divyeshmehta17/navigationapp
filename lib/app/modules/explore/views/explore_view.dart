import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/components/customtextfield.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../components/navigationAppButton.dart';
import '../../../customwidgets/addplacebutton.dart';
import '../../../customwidgets/savedLocationCard.dart';
import '../../directioncard/views/directioncard_view.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.globalController.currentLatitude.value,
                  controller.globalController.currentLongitude.value,
                ),
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController mapController) {
                controller.globalController.setMapController(mapController);
              },
            ),

            // Sliding Up Panel
            controller.savedLocations.value == null
                ? CircularProgressIndicator()
                : Obx(
                    () => SlidingUpPanel(
                      controller: controller.panelController,
                      panelBuilder: (sc) => _panelContent(controller, context),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18.0)),
                      minHeight: 150,
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                      panelSnapping: true,
                      isDraggable: controller.isDraggable.value,
                      body: Stack(
                        children: [
                          Obx(() {
                            final position = controller.panelPosition.value;
                            final offset = 400.0 -
                                (position *
                                    (MediaQuery.of(context).size.height *
                                        0.35));
                            return Positioned(
                              top: offset,
                              right: 15,
                              child: Column(
                                children: [
                                  _iconButton(
                                    ImageConstant.svgmapStyleIcon,
                                    controller.panelController,
                                    Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  _iconButton(
                                    ImageConstant.svgLocation,
                                    controller.panelController,
                                    Colors.white,
                                    onTap: () {
                                      controller.globalController
                                          .goToCurrentLocation(controller
                                              .globalController.mapController!);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _iconButton(
                                    ImageConstant.svgreportIcon,
                                    controller.panelController,
                                    Colors.red,
                                    onTap: controller.toggleReportOptions,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      onPanelSlide: (position) {
                        controller.panelPosition.value = position;
                      },
                    ),
                  )
          ],
        ),
      ),
      // Bottom Navigation Bar
    );
  }

  Widget _panelContent(ExploreController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.kw),
      child: Obx(() {
        if (controller.showReportOptions.value) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPanelHandle().paddingOnly(bottom: 18.kh),
              Text(
                'Add a report',
                style: TextStyle(fontSize: 18.kh, fontWeight: FontWeight.bold),
              ),
              GridView.count(crossAxisCount: 3, shrinkWrap: true, children: [
                _reportButton(
                    ImageConstant.svgcarcrashicon, 'Car crash', Colors.red,
                    (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Car Crash'
                    }, // Replace with your desired type
                  );
                }, 0),
                _reportButton(
                    ImageConstant.svgcongestionIcon, 'Congestion', Colors.red,
                    (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Congestion'
                    }, // Replace with your desired type
                  );
                }, 1),
                _reportButton(
                    ImageConstant.svgroadworkIcon, 'Roadwork', Colors.orange,
                    (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Roadwork'
                    }, // Replace with your desired type
                  );
                }, 2),
                _reportButton(ImageConstant.svgroadclosedIcon, 'Road closed',
                    Colors.orange, (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Road closed'
                    }, // Replace with your desired type
                  );
                }, 3),
                _reportButton(ImageConstant.svgvechilestalledIcon,
                    'Vehicle stalled', Colors.orange, (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Vehicle stalled'
                    }, // Replace with your desired type
                  );
                }, 4),
                _reportButton(
                    ImageConstant.svgpoliceIcon, 'Police', Colors.orange,
                    (index) {
                  Get.toNamed(
                    Routes.REPORTINCIDENT,
                    arguments: {
                      'preSelectedIncidentType': 'Police'
                    }, // Replace with your desired type
                  );
                }, 5),
              ]),
              NavigationAppButton(
                label: 'Cancel',
                onTap: controller.toggleReportOptions,
                color: context.brandColor1,
                textStyle: TextStyleUtil.poppins600(
                    fontSize: 16.kh, color: Colors.white),
                leadinglabelpadding: EdgeInsets.symmetric(vertical: 12.kh),
                borderRadius: BorderRadius.circular(48.kw),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const buildPanelHandle().paddingOnly(bottom: 18.kh),
              CustomTextField(
                enabled: false,
                color: context.neutralGrey,
                decoration: InputDecoration(
                  hintText: 'Enter your destination..',
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: context.lightGrey),
                      borderRadius: BorderRadius.circular(8.kw)),
                  hintStyle: TextStyleUtil.poppins400(
                      fontSize: 14.kh, color: context.darkGrey),
                  contentPadding: EdgeInsets.only(top: 14.kh),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.kw)),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: context.darkGrey,
                  ),
                  suffixIcon: Icon(
                    CupertinoIcons.mic,
                    color: context.darkGrey,
                  ),
                ),
                onGestureTap: () {
                  Get.toNamed(Routes.SEARCHVIEW);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Saved',
                      style: TextStyleUtil.poppins500(
                        fontSize: 14.kh,
                      )),
                  TextButton(
                      onPressed: () async {
                        Get.toNamed(Routes.SAVED);
                      },
                      child: const Text('See All')),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      controller.savedLocations.value!.data!.results!.length +
                          1, // 9 items + 1 for the "Add" button
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    // Check if this is the last item in the list
                    if (index ==
                        controller
                            .savedLocations.value!.data!.results!.length) {
                      // Return the "Add" button at the end
                      return const AddButton();
                    } else {
                      // Return the saved location cards
                      return GestureDetector(
                        onTap: () {
                          controller.fetchPlaceDetails(
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
                              placeId: controller.savedLocations.value!.data!
                                  .results![index]!.placeId
                                  .toString());
                        },
                        child: savedLocationCard(
                            svgPath: controller.savedLocations.value!.data!
                                        .results![index]!.title ==
                                    'Home'
                                ? ImageConstant.svghomeIcon
                                : controller.savedLocations.value!.data!
                                            .results![index]!.title ==
                                        'Office'
                                    ? ImageConstant.svgofficeIcon
                                    : ImageConstant.svgsavedIconsblack,
                            name: controller.savedLocations!.value!.data!
                                .results![index]!.title),
                      );
                    }
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Recent',
                    style: TextStyleUtil.poppins500(
                      fontSize: 14.kh,
                    )),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.SEARCHVIEW);
                    },
                    child: Text(
                      'See All',
                      style: TextStyleUtil.poppins400(
                          fontSize: 12.kh, color: context.brandColor1),
                    )),
              ]).paddingOnly(bottom: 10.kh),
              Obx(() => controller.searchLocations.value == null ||
                      controller.searchLocations.value!.data!.results!.isEmpty
                  ? Center(
                      child: Text(
                        'No recent search history',
                        style: TextStyleUtil.poppins400(fontSize: 14.kh),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              controller.fetchPlaceDetails(
                                  destinationlatitude: controller
                                      .searchLocations
                                      .value!
                                      .data!
                                      .results![index + 1]!
                                      .location!
                                      .coordinates![0]!
                                      .toString(),
                                  destinationlongitude: controller
                                      .searchLocations
                                      .value!
                                      .data!
                                      .results![index + 1]!
                                      .location!
                                      .coordinates![1]!
                                      .toString(),
                                  placeId: controller.searchLocations.value!
                                      .data!.results![index + 1]!.placeId
                                      .toString());
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.history),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                            .searchLocations
                                            .value!
                                            .data!
                                            .results![index + 1]!
                                            .location!
                                            .addressLine
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )),
            ],
          );
        }
      }),
    );
  }

  Widget _reportButton(String icon, String label, Color color,
      void Function(int)? onTap, int index) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(index); // Pass the index when tapped
          print(index);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.kw,
            backgroundColor: color,
            child: CommonImageView(
              svgPath: icon,
              height: 25.kh,
              width: 25.kw,
              svgColor: Colors.white,
            ),
          ),
          SizedBox(height: 15.kh),
          Text(label, style: TextStyleUtil.poppins400(fontSize: 12.kh)),
        ],
      ),
    );
  }

  Widget _iconButton(
    String icon,
    PanelController panelController,
    Color? backgroundColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          if (panelController.isAttached) {
            if (panelController.isPanelOpen) {
              panelController.close();
            } else {
              panelController.open();
            }
          }
        }
      },
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: CommonImageView(
          svgPath: icon,
        ),
      ),
    );
  }
}
