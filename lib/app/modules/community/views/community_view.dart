import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/modules/community/controllers/community_controller.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.kw, vertical: 24.kh),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.kw)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(), // Placeholder for alignment
                          Text(
                            'Add a filter',
                            style: TextStyleUtil.poppins500(fontSize: 16.kh),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(CupertinoIcons.clear, size: 24.kh),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Distance',
                        style: TextStyleUtil.poppins500(fontSize: 14.kh),
                      ),
                      Obx(
                        () => SfRangeSlider(
                          min: 0.0,
                          max: 10.0,
                          values: SfRangeValues(
                            controller.distanceRange.value.start,
                            controller.distanceRange.value.end,
                          ),
                          interval: 2, // Display ticks at 0, 2, 5, 8, and 10 km
                          showTicks: true,
                          showLabels: true,
                          // stepSize: 2, // Allow snapping to predefined steps
                          labelFormatterCallback:
                              (dynamic value, String label) {
                            return '${value.round()} km'; // Format labels as "X km"
                          },
                          enableTooltip: true, // Tooltip on drag
                          activeColor: Colors.deepPurple,
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (SfRangeValues newRange) {
                            double start =
                                controller.roundToStep(newRange.start);
                            double end = controller.roundToStep(newRange.end);
                            controller
                                .updateDistanceRange(RangeValues(start, end));
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Time of posting',
                        style: TextStyleUtil.poppins500(fontSize: 14.kh),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => ToggleButtons(
                          isSelected: List.generate(
                              3,
                              (index) =>
                                  controller.selectedTimeFilter.value == index),
                          onPressed: (int index) {
                            controller.selectedTimeFilter.value = index;
                          },
                          borderColor: Colors.grey.shade300,
                          selectedBorderColor: context.brandColor1,
                          selectedColor: Colors.white,
                          color: Colors.black,
                          fillColor: context.brandColor1,
                          borderRadius: BorderRadius.circular(8),
                          textStyle: TextStyleUtil.poppins500(
                              fontSize: 12.kh, color: Colors.black),
                          constraints: BoxConstraints(
                              minHeight: 40.kh, minWidth: 118.kw),
                          children: const [
                            Text(
                              'Today',
                            ),
                            Text(
                              '3 days back',
                            ),
                            Text(
                              '7 days back',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.fetchCommunityPostApi();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.brandColor1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.kw),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 48.kw, vertical: 12.kh),
                          ),
                          child: Text(
                            'Apply filters',
                            style: TextStyle(
                              fontSize: 16.kh,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: CommonImageView(
              svgPath: ImageConstant.svgfilterIcon,
            ).paddingOnly(right: 18.kw),
          )
        ],
        title: Text(
          'Community Feed',
          style: TextStyleUtil.poppins500(fontSize: 18.kh),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchCommunityPostApi(),
        child: Obx(() {
          final posts = controller.reversedCommunityPosts;
          return posts == null || posts.isEmpty
              ? const Center(
                  child: Text(
                    'No recent incidents found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final DateTime createdAt =
                        DateTime.parse(post.createdAt).toUtc();
                    final DateTime localTime = createdAt.toLocal();
                    final String formattedTime =
                        DateFormat('hh:mm a').format(localTime);

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPostHeader(post),
                          _buildPostBody(post, formattedTime),
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget _buildTimeFilterOption(String label, int index, BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => controller.updateSelectedTimeFilter(index),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.kw, vertical: 8.kh),
  //       decoration: BoxDecoration(
  //         color: controller.selectedTimeFilter.value == index
  //             ? context.brandColor1
  //             : Colors.grey.shade200,
  //         borderRadius: BorderRadius.horizontal(
  //             left: Radius.circular(8.kw), right: Radius.circular(8.kw)),
  //       ),
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12.kh,
  //           fontWeight: FontWeight.w500,
  //           color: controller.selectedTimeFilter.value == index
  //               ? Colors.white
  //               : Colors.grey.shade700,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPostHeader(dynamic post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person))
                .paddingOnly(right: 8.kw),
            Text(
              post.createdBy.name.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(CupertinoIcons.share, color: Get.context!.brandColor1),
      ],
    );
  }

  Widget _buildPostBody(dynamic post, String formattedTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(post.description.toString(), style: TextStyle(fontSize: 14.kh)),
        const SizedBox(height: 8),
        if (post.postMedia != null &&
            post.postMedia!.isNotEmpty &&
            post.postMedia![0].url.toString().isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(18.kw),
            child: AspectRatio(
              aspectRatio: 1.88,
              child: CommonImageView(
                url: post.postMedia![0].url.toString(),
                height: 150.kh,
                width: 280.kw,
              ),
            ),
          ),
        const SizedBox(height: 8),
        _buildPostDetails(post, formattedTime),
      ],
    ).paddingOnly(left: 50.kw);
  }

  Widget _buildPostDetails(dynamic post, String formattedTime) {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 8,
      shrinkWrap: true,
      children: [
        Row(
          children: [
            CommonImageView(
              svgPath: controller.getIncidentIconPath(post.typeOfIncident),
              height: 15.kh,
              width: 15.kw,
              fit: BoxFit.contain,
              svgColor: Colors.grey.shade900,
            ),
            SizedBox(width: 4.kh),
            Expanded(
              child: Text(
                post.typeOfIncident.toString(),
                style: TextStyle(fontSize: 12.kh, color: Colors.grey.shade900),
              ),
            ),
            Icon(CupertinoIcons.clock,
                size: 16.kh, color: Colors.grey.shade900),
            SizedBox(width: 4.kh),
            Expanded(
              child: Text(
                formattedTime,
                style: TextStyle(fontSize: 12.kh, color: Colors.grey.shade900),
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
              svgColor: Colors.grey.shade900,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                post.location.addressLine.toString() ?? 'Unknown location',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 12.kh,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey.shade900),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
