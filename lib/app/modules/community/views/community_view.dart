import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/modules/community/controllers/community_controller.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => ReportincidentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.fetchCommunityPostApi();
        },
        child: Obx(() {
          return controller.fetchCommunityPost.value == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.fetchCommunityPost.value!.data!.length,
                  itemBuilder: (context, index) {
                    // final report = controller.incidentReports[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ).paddingOnly(right: 8.kw),
                                  Text(
                                    controller.fetchCommunityPost.value!
                                        .data![index]!.createdBy!.name
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Icon(
                                CupertinoIcons.share,
                                color: context.brandColor1,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                controller.fetchCommunityPost.value!
                                    .data![index]!.description
                                    .toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              if (controller.fetchCommunityPost.value!
                                  .data![index]!.postMedia![0]!.url
                                  .toString()
                                  .isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18.kw),
                                  child: CommonImageView(
                                    url: controller.fetchCommunityPost.value!
                                        .data![index]!.postMedia![0]!.url,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CommonImageView(
                                      svgPath: ImageConstant.svgcarcrashicon,
                                      height: 15.kh,
                                      width: 15.kw,
                                      fit: BoxFit.contain,
                                      svgColor: Colors.grey.shade900),
                                  SizedBox(width: 4.kh),
                                  Expanded(
                                    child: Text(
                                      controller.fetchCommunityPost.value!
                                          .data![index]!.typeOfIncident
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12.kh,
                                          color: Colors.grey.shade900),
                                    ),
                                  ),
                                  Icon(CupertinoIcons.clock,
                                      size: 16.kh, color: Colors.grey.shade900),
                                  SizedBox(width: 4.kh),
                                  Expanded(
                                    child: Text(
                                      '${controller.fetchCommunityPost.value!.data![index]!.createdAt}',
                                      style: TextStyle(
                                          fontSize: 12.kh,
                                          color: Colors.grey.shade900),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CommonImageView(
                                      svgPath: ImageConstant.svgLocation,
                                      height: 15.kh,
                                      width: 15.kw,
                                      fit: BoxFit.contain,
                                      svgColor: Colors.grey.shade900),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      controller.fetchCommunityPost.value!
                                          .data![index]!.location!.addressLine
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12.kh,
                                          color: Colors.grey.shade900),
                                    ),
                                  ),
                                  // const Icon(
                                  //     CupertinoIcons.exclamationmark_triangle,
                                  //     size: 16,
                                  //     color: Colors.grey),
                                  // const SizedBox(width: 4),
                                  // const Expanded(
                                  //   child: Text(
                                  //     '${1} users reported this',
                                  //     style: TextStyle(
                                  //         fontSize: 12, color: Colors.grey),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ).paddingOnly(left: 50.kw),
                        ],
                      ),
                    );
                  },
                );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.REPORTINCIDENT),
        shape: const StadiumBorder(),
        backgroundColor: context.brandColor1,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
