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

import '../../../customwidgets/savedLocationCard.dart';
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
            SlidingUpPanel(
              controller: controller.panelController,
              panelBuilder: (sc) => _panelContent(controller, context),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18.0)),
              minHeight: 150,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              body: Stack(
                children: [
                  Obx(() {
                    final position = controller.panelPosition.value;
                    final offset = 400.0 -
                        (position *
                            (MediaQuery.of(context).size.height * 0.35));
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
                              controller.globalController.goToCurrentLocation(
                                  controller.globalController.mapController!);
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
          ],
        ),
      ),
      // Bottom Navigation Bar
    );
  }

  Widget _panelContent(ExploreController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Obx(() {
        if (controller.showReportOptions.value) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _reportButton(Icons.directions_car, 'Car crash', Colors.red),
                  _reportButton(Icons.traffic, 'Congestion', Colors.red),
                  _reportButton(Icons.construction, 'Roadwork', Colors.orange),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _reportButton(Icons.block, 'Road closed', Colors.orange),
                  _reportButton(
                      Icons.directions_bus, 'Vehicle stalled', Colors.orange),
                  _reportButton(Icons.local_police, 'Police', Colors.orange),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Background color
                ),
                onPressed: controller.toggleReportOptions,
                child: const Text('Cancel'),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                enabled: false,
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
                      onPressed: () async {}, child: const Text('See All')),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...controller.savedLocations.map((location) {
                      return savedLocationCard(location, context);
                    }),
                    _addButton(context),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent',
                      style: TextStyleUtil.poppins500(
                        fontSize: 14.kh,
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyleUtil.poppins400(
                            fontSize: 12.kh, color: context.brandColor1),
                      )),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  final location = controller.recentLocations[index];
                  return recentLocationList(location, context);
                },
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _reportButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, size: 30, color: color),
        ),
        SizedBox(height: 5.kh),
        Text(label, style: TextStyle(color: color)),
      ],
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

  Widget _addButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ADDAPLACE);
      },
      child: Container(
        width: 67.kw,
        height: 85.kh,
        margin: EdgeInsets.symmetric(horizontal: 10.kw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.kw),
          color: context.brandColor1,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
