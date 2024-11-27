import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/customwidgets/buildLocationInputField.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../customwidgets/globalalertdialog.dart';
import '../controllers/addaplace_controller.dart';

class AddaplaceView extends GetView<AddaplaceController> {
  const AddaplaceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.searchSuggestions.clear();
        FocusScope.of(context).unfocus(); // Close the keyboard if open
      },
      child: Scaffold(
          appBar: CustomAppBar(
            title: 'Add A Place',
          ),
          body: Obx(
            () => Stack(
              children: [
                SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      children: [
                        buildLocationInputField(
                          hintText: 'Enter Your Destination',
                          controller: controller.searchcontroller,
                          itemClick: (Prediction) {
                            controller
                                .fetchPlaceDetails(
                                    Prediction.placeId.toString())
                                .then((response) {
                              controller.placeId.value =
                                  Prediction.placeId.toString();
                              print(controller.placeId);
                              showGlobalDialog(
                                  title: 'Add to saved places ?',
                                  optionalcontent: Column(
                                    children: [
                                      Text(
                                          'Do you want to add “${controller.placeName.value}” to saved places ?'),
                                      DropdownMenu(
                                        hintText: 'Select Saved Location Type',
                                        onSelected: (value) {
                                          controller.savedLocationType.value =
                                              value == 0
                                                  ? 'Home'
                                                  : value == 1
                                                      ? 'Office'
                                                      : 'Others';
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: 0,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svghomeIcon,
                                            ),
                                            label: 'Home',
                                          ),
                                          DropdownMenuEntry(
                                            value: 1,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svgofficeIcon,
                                            ),
                                            label: 'Office',
                                          ),
                                          DropdownMenuEntry(
                                            value: 2,
                                            leadingIcon: CommonImageView(
                                              svgPath: ImageConstant
                                                  .svgsavedIconsblack,
                                            ),
                                            label: 'Others',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  onConfirm: () {
                                    controller.saveSearchedLocation();
                                  },
                                  context: context);
                            });
                          },
                          context: context,
                          focusNode: FocusNode(),
                          color: context.neutralGrey,
                          textColor: context.darkGrey,
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            size: 20.kh,
                          ),
                          suffixIcon: Obx(
                            () => IconButton(
                              icon: Icon(
                                controller.isListening.value
                                    ? CupertinoIcons.mic_fill
                                    : CupertinoIcons.mic,
                                color: context.darkGrey,
                              ),
                              onPressed: () {
                                if (controller.isListening.value) {
                                  controller.stopListening();
                                } else {
                                  controller.startListening();
                                }
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.getCurrentLocation().then((response) {
                              return showGlobalDialog(
                                  title: 'Add to saved places ?',
                                  optionalcontent: Column(
                                    children: [
                                      Text(
                                          'Do you want to add “${controller.placeName.value}” to saved places ?'),
                                      DropdownMenu(
                                        hintText: 'Select Saved Location Type',
                                        onSelected: (value) {
                                          controller.savedLocationType.value =
                                              value == 0
                                                  ? 'Home'
                                                  : value == 1
                                                      ? 'Office'
                                                      : 'Others';
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: 0,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svghomeIcon,
                                            ),
                                            label: 'Home',
                                          ),
                                          DropdownMenuEntry(
                                            value: 1,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svgofficeIcon,
                                            ),
                                            label: 'Office',
                                          ),
                                          DropdownMenuEntry(
                                            value: 2,
                                            leadingIcon: CommonImageView(
                                              svgPath: ImageConstant
                                                  .svgsavedIconsblack,
                                            ),
                                            label: 'Others',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  onConfirm: () {
                                    controller.saveCurrentLocation();
                                  },
                                  context: context);
                            });
                          },
                          child: Obx(() => controller.isLoading.value
                              ? Center(
                                  child: Column(
                                    children: [
                                      Text('Fetching Your Current Location...'),
                                      SpinKitThreeBounce(
                                        color: context.brandColor1,
                                        size: 20.kh,
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_off_rounded,
                                      color: context.brandColor1,
                                    ).paddingOnly(right: 8.kw),
                                    Text(
                                      'Your Location',
                                      style: TextStyleUtil.poppins500(
                                          fontSize: 14.kh),
                                    )
                                  ],
                                ).paddingOnly(top: 16.kh)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent',
                                style: TextStyleUtil.poppins500(
                                  fontSize: 14.kh,
                                )),
                            TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.SEARCHVIEW);
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyleUtil.poppins400(
                                      fontSize: 12.kh,
                                      color: context.brandColor1),
                                )),
                          ],
                        ),
                        Divider(
                          color: context.lightGrey,
                        ),
                        controller.searchLocationsHistory.value == null
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                                itemCount: controller.searchLocationsHistory
                                    .value!.data!.results!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final recentSearch = controller
                                      .searchLocationsHistory
                                      .value!
                                      .data!
                                      .results![index];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Row(children: [
                                      const Icon(Icons.history)
                                          .paddingOnly(right: 18.kw),
                                      Expanded(
                                        child: Text(
                                          recentSearch!.location!.addressLine
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyleUtil.poppins400(
                                              fontSize: 14.kh),
                                        ),
                                      ),
                                    ]).paddingOnly(top: 18.kh),
                                  );
                                },
                              ),
                      ],
                    ).paddingSymmetric(horizontal: 16.kw, vertical: 16.kh),
                  ),
                ),
                if (controller.searchSuggestions.isNotEmpty)
                  Positioned(
                    top: 80
                        .kh, // Adjust the position to fit below the search bar
                    left: 18.kw,
                    right: 18.kw,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.kw),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: controller.searchSuggestions.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 8.kh),
                        itemBuilder: (context, index) {
                          final prediction =
                              controller.searchSuggestions[index];
                          return ListTile(
                            title: Text(
                              prediction.description ?? "",
                              style: TextStyleUtil.poppins400(fontSize: 14.kh),
                            ),
                            onTap: () {
                              controller
                                  .fetchPlaceDetails(
                                      prediction.placeId.toString())
                                  .then((response) {
                                controller.placeId.value =
                                    prediction.placeId.toString();
                                print(controller.placeId);
                                showGlobalDialog(
                                  title: 'Add to saved places ?',
                                  optionalcontent: Column(
                                    children: [
                                      Text(
                                        'Do you want to add “${controller.placeName.value}” to saved places ?',
                                      ),
                                      DropdownMenu(
                                        hintText: 'Select Saved Location Type',
                                        onSelected: (value) {
                                          controller.savedLocationType.value =
                                              value == 0
                                                  ? 'Home'
                                                  : value == 1
                                                      ? 'Office'
                                                      : 'Others';
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: 0,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svghomeIcon,
                                            ),
                                            label: 'Home',
                                          ),
                                          DropdownMenuEntry(
                                            value: 1,
                                            leadingIcon: CommonImageView(
                                              svgPath:
                                                  ImageConstant.svgofficeIcon,
                                            ),
                                            label: 'Office',
                                          ),
                                          DropdownMenuEntry(
                                            value: 2,
                                            leadingIcon: CommonImageView(
                                              svgPath: ImageConstant
                                                  .svgsavedIconsblack,
                                            ),
                                            label: 'Others',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onConfirm: () {
                                    controller.saveSearchedLocation();
                                  },
                                  context: context,
                                );
                              });
                            },
                          );
                        },
                      ),
                    ).paddingOnly(top: 8.kh),
                  ),
                if (controller.isListening.value == true)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20.kh),
                        Text(
                          'Listening...',
                          style: TextStyleUtil.poppins600(
                              fontSize: 18.kh, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
