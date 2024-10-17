import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mopedsafe/app/components/navigationAppButton.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../customwidgets/buildSlidingUpPanel.dart';
import '../controllers/realtimenavigation_controller.dart';

class RealtimenavigationView extends GetView<RealtimenavigationController> {
  const RealtimenavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            GoogleMap(
              polylines: controller.polylines,
              markers: Set<Marker>.of(controller.markers),
              compassEnabled: true,
              trafficEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      controller.globalController.currentLatitude.toDouble(),
                      controller.globalController.currentLongitude
                          .toDouble()), // Example positio
                  zoom: 17),
            ),
            Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: controller.userSpeed.toStringAsFixed(2),
                            style: TextStyleUtil.poppins500(fontSize: 20.kh),
                          ),
                          TextSpan(
                            text: '\nkm/h',
                            style: TextStyleUtil.poppins500(fontSize: 10.kh),
                          )
                        ])).paddingAll(16.kw))
                .paddingOnly(bottom: 250.kh),
            //39129/-
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.kw),
                    color: context.brandColor1,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.maneuverIcon.value,
                        size: 50.kh,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.maneuverText.value,
                        style: TextStyle(color: Colors.white, fontSize: 18.kh),
                      ),
                    ],
                  ),
                );
              }),
            ),
            SlidingUpPanelWidget(
              panelController: controller.panelController,
              minHeight: 25.h,
              maxHeight: 30.h,
              panelContentBuilder: (context) => Container(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.totalduration.toStringAsFixed(2)} mins (${controller.totalDistance.toStringAsFixed(2)} km)',
                              style: TextStyleUtil.poppins400(
                                  fontSize: 19.kh, color: context.brandColor1),
                            ),
                            Text(
                              'ETA: ${controller.formatEstimatedTime(controller.estimatedTime.value)}',
                              style: TextStyleUtil.poppins400(fontSize: 14.kh),
                            ),
                          ],
                        ),
                        NavigationAppButton(
                          label: 'Exit',
                          onTap: () {
                            controller.positionStreamSubscription!
                                .cancel()
                                .then((onValue) {
                              Get.back();
                            });
                          },
                          color: context.brandColor1,
                          borderRadius: BorderRadius.circular(48.kw),
                          textStyle: TextStyleUtil.poppins600(
                              fontSize: 16.kh, color: Colors.white),
                          leadinglabelpadding: EdgeInsets.symmetric(
                              vertical: 12.kh, horizontal: 16.kh),
                        )
                      ],
                    ).paddingAll(20.kh),
                    Divider(
                      color: context.darkGrey,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.shareLocation();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.share_outlined)
                              .paddingOnly(left: 18.kw, right: 12.kw),
                          Text(
                            'Share Route',
                            style: TextStyleUtil.poppins500(
                              fontSize: 14.kh,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: context.darkGrey,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.list)
                              .paddingOnly(left: 18.kw, right: 12.kw),
                          Text(
                            'See directions',
                            style: TextStyleUtil.poppins500(
                              fontSize: 14.kh,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
