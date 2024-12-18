import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../controllers/offlineroutes_controller.dart';

class OfflineroutesView extends GetView<OfflineroutesController> {
  const OfflineroutesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Offline Routes',
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.getsavedOfflineRoutes.value!.results!.length,
          itemBuilder: (context, index) {
            final route =
                controller.getsavedOfflineRoutes.value!.results![index];
            return GestureDetector(
              onTap: () {
                controller.decodePolyline(route.points.toString());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                route!.startName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyleUtil.poppins500(fontSize: 14.kh),
                              ),
                              const Icon(Icons.arrow_forward)
                                  .paddingOnly(left: 8.kw, right: 8.kw),
                              Text(
                                route.endName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyleUtil.poppins500(fontSize: 14.kh),
                              ),
                            ],
                          ),
                          Text(
                            'approx: ${route.distance} km',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleUtil.poppins400(fontSize: 12.kh),
                          )
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Handle more options here
                        },
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ).paddingOnly(left: 18.kw, right: 18.kw),
            );
          },
        ).paddingOnly(top: 8.kh);
      }),
    );
  }
}
