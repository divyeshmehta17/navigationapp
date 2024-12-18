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
              polylines: controller.polylines.toSet(),
              markers: Set<Marker>.of(controller.markers),
              indoorViewEnabled: true,
              buildingsEnabled: false,
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
                      Column(
                        children: [
                          Icon(
                            controller.maneuverIcon.value,
                            size: 40.kh,
                            color: Colors.white,
                          ),
                          Text(
                            '200m',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.kh),
                          ),
                        ],
                      ).paddingOnly(left: 8.kw),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.maneuverText.value,
                            style: TextStyleUtil.poppins500(
                                color: Colors.white, fontSize: 20.kh),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Towards Jaywant Sawant Road',
                            style: TextStyleUtil.poppins400(
                                color: Colors.white, fontSize: 14.kh),
                          ).paddingOnly(top: 8.kw),
                        ],
                      ),
                    ],
                  ).paddingOnly(top: 8.kh, bottom: 8.kh),
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
                            Obx(
                              () => Text(
                                '0h 30m  (${((controller.globalController.directionCardData.value!.distance) / 1000).toStringAsFixed(2)} km)',
                                style: TextStyleUtil.poppins400(
                                    fontSize: 19.kh,
                                    color: context.brandColor1),
                              ),
                            ),
                            Text(
                              'ETA: 4:30 PM',
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
