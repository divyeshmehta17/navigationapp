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
        return controller.getsavedOfflineRoutes.value! == null
            ? RefreshIndicator(
                onRefresh: () async {
                  controller.loadOfflineRoutes(); // Trigger fetch on refresh
                },
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      controller.fetchSavedRoutes();
                    },
                    child: Text(
                      'No offline routes found',
                      style: TextStyleUtil.poppins500(
                        fontSize: 14.kh,
                      ),
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  controller.loadOfflineRoutes(); // Trigger fetch on refresh
                },
                child: ListView.builder(
                  itemCount: controller
                      .getsavedOfflineRoutes.value!.data!.results!.length,
                  itemBuilder: (context, index) {
                    final route = controller.getsavedOfflineRoutes.value!.data!
                      ..results![index];
                    return GestureDetector(
                      onTap: () {
                        controller.decodePolyline(
                            route.results![index]!.points.toString());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          route.results![index]!.startName
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyleUtil.poppins500(
                                              fontSize: 14.kh),
                                        ),
                                        const Icon(Icons.arrow_forward)
                                            .paddingOnly(
                                                left: 8.kw, right: 8.kw),
                                        Expanded(
                                          child: Text(
                                            route.results![index]!.endName
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyleUtil.poppins500(
                                                fontSize: 14.kh),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'approx: ${route.results![index]!.distance} km',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyleUtil.poppins400(
                                          fontSize: 12.kh),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // Handle more options here
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ).paddingOnly(left: 18.kw, right: 18.kw),
                    );
                  },
                ).paddingOnly(top: 8.kh),
              );
      }),
    );
  }
}
