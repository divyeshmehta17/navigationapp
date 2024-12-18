import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/modules/directioncard/views/directioncard_view.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SavedController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Routes',
          style: TextStyleUtil.poppins500(fontSize: 18.kh),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchSavedRoutes();
        },
        child: Obx(() {
          return controller.getsavedRoutes.value == null
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      controller.getsavedRoutes.value!.data!.results!.length,
                  itemBuilder: (context, index) {
                    print(
                        'approx ${(controller.getsavedRoutes.value!.data!.results![index]!.distance!)}');
                    return GestureDetector(
                      onTap: () {
                        controller.fetchPlaceDetails(
                            controller.getsavedRoutes.value!.data!
                                .results![index]!.placeId!,
                            index);
                      },
                      child: ListTile(
                        titleTextStyle:
                            TextStyleUtil.poppins500(fontSize: 14.kh),
                        title: Text(
                            '${controller.getsavedRoutes.value!.data!.results![index]!.startName.toString()}→${controller.getsavedRoutes.value!.data!.results![index]!.endName.toString()}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'approx ${((controller.getsavedRoutes.value!.data!.results![index]!.distance!) / 1000).toStringAsFixed(2)} kms',
                              style: TextStyleUtil.poppins400(fontSize: 12.kh),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            Get.bottomSheet(
                                isScrollControlled: false,
                                enableDrag: true,
                                Container(
                                  height: 160.kh,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(18.kw),
                                          right: Radius.circular(18.kw))),
                                  child: Column(
                                    children: [
                                      buildPanelHandle(),
                                      Row(
                                        children: [
                                          Icon(Icons.cut)
                                              .paddingOnly(right: 8.kw),
                                          Text(
                                            'Edit route',
                                            style: TextStyleUtil.poppins500(
                                                fontSize: 14.kh),
                                          )
                                        ],
                                      ).paddingOnly(top: 8.kh),
                                      Divider(
                                        color: context.darkGrey,
                                      ).paddingOnly(top: 12.kh, bottom: 12.kh),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_outlined),
                                            color: Colors.red,
                                            onPressed: () {
                                              print(controller
                                                  .getsavedRoutes
                                                  .value!
                                                  .data!
                                                  .results![index]!
                                                  .Id
                                                  .toString());
                                              controller.deleteSavedRoute(
                                                  controller
                                                      .getsavedRoutes
                                                      .value!
                                                      .data!
                                                      .results![index]!
                                                      .Id
                                                      .toString());
                                            },
                                          ).paddingOnly(right: 8.kw),
                                          Text(
                                            'Delete route',
                                            style: TextStyleUtil.poppins500(
                                                fontSize: 14.kh,
                                                color: Colors.red),
                                          )
                                        ],
                                      )
                                    ],
                                  ).paddingOnly(
                                      left: 18.kw, right: 18.kw, top: 18.kh),
                                ));
                          },
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
