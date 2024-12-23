import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
                    polylineId: const PolylineId('route'),
                    points: controller.polylineCoordinates,
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
                    controller.polylineCoordinates[0].latitude,
                    controller.polylineCoordinates[0].longitude,
                  ),
                  zoom: 17,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // controller.updateManeuverText(controller.currentPosition);
                },
                child: Container(
                  decoration: const BoxDecoration(
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
                      ),
                    ]),
                  ).paddingAll(16.kw),
                ).paddingOnly(bottom: 250.kh),
              ),
              Positioned(
                top: 50,
                left: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.brandColor1,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Obx(
                    () => Row(
                      children: [
                        Column(
                          children: [
                            Icon(
                              controller.getManeuverIcon(
                                  controller.directionText.value),
                              size: 50.kh,
                              color: Colors.white,
                            ),
                            Text(
                              controller.directionTurnText.value,
                              style: TextStyleUtil.poppins400(
                                fontSize: 19.kh,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Html(
                            data: controller.maneuverText.value,
                            style: {
                              "body": Style(
                                color: Colors.white,
                                fontSize: FontSize(18),
                              ),
                              "div": Style(
                                color: Colors.white70,
                                fontSize: FontSize(14),
                              ),
                              "b": Style(
                                fontWeight: FontWeight.bold,
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                                '${controller.getSavedRoutes!.data!.results![0]!.distance} km',
                                style: TextStyleUtil.poppins400(
                                  fontSize: 19.kh,
                                  color: context.brandColor1,
                                ),
                              ),
                              Text(
                                'ETA: ${controller.getSavedRoutes!.data!.results![0]!.time} mins',
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
