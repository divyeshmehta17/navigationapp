import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/navigationAppButton.dart';
import '../../../customwidgets/buildSlidingUpPanel.dart';
import '../../../services/text_style_util.dart';
import '../controllers/savedrealtimenavigation_controller.dart';

class SavedrealtimenavigationView
    extends GetView<SavedrealtimenavigationController> {
  const SavedrealtimenavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              GoogleMap(
                polylines: {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: controller.polylinecoordinates,
                    color: Colors.blue,
                    width: 5,
                  )
                },
                compassEnabled: true,
                trafficEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.polylinecoordinates[0].latitude,
                    controller.polylinecoordinates[0].longitude,
                  ),
                  zoom: 17,
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                    ),
                  ]),
                ).paddingAll(16.kw),
              ).paddingOnly(bottom: 250.kh),
              Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.kw),
                      color: context.brandColor1,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.left_chevron,
                          size: 50.kh,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          controller.maneuverText.value,
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.kh),
                        ),
                      ],
                    ),
                  )),
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
                                '${controller.getSavedRoutes!.value!.data!.results![0]!.distance} km',
                                style: TextStyleUtil.poppins400(
                                  fontSize: 19.kh,
                                  color: context.brandColor1,
                                ),
                              ),
                              Text(
                                'ETA: ${controller.getSavedRoutes!.value!.data!.results![0]!.time} mins',
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh),
                              ),
                            ],
                          ),
                          NavigationAppButton(
                            label: 'Exit',
                            onTap: () {},
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
                        onTap: () {},
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
