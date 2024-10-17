import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/customwidgets/buildLocationInputField.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../customwidgets/globalalertdialog.dart';
import '../../../customwidgets/savedLocationCard.dart';
import '../controllers/addaplace_controller.dart';

class AddaplaceView extends GetView<AddaplaceController> {
  const AddaplaceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add A Place',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildLocationInputField(
                hintText: 'Enter Your Destination',
                controller: controller.searchcontroller,
                itemClick: (Prediction) {
                  controller.fetchPlaceDetails(Prediction.placeId.toString());
                },
                context: context,
                focusNode: FocusNode(),
                color: context.neutralGrey,
                textColor: context.darkGrey,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  size: 20.kh,
                ),
                suffixIcon: Icon(
                  CupertinoIcons.mic,
                  size: 20.kh,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.getCurrentLocation().then((response) {
                    return showGlobalDialog(
                        title: 'Add to saved places ?',
                        content:
                            'Do you want to add “${controller.placeName.value}” to saved places ?',
                        onConfirm: () {
                          controller.saveCurrentLocation();
                        },
                        context: context);
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.radio_button_off_rounded,
                      color: context.brandColor1,
                    ).paddingOnly(right: 8.kw),
                    Text(
                      'Your Location',
                      style: TextStyleUtil.poppins500(fontSize: 14.kh),
                    )
                  ],
                ).paddingOnly(top: 16.kh),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent',
                      style: TextStyleUtil.poppins500(
                        fontSize: 14.kh,
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyleUtil.poppins400(
                            fontSize: 12.kh, color: context.brandColor1),
                      )),
                ],
              ),
              Divider(
                color: context.lightGrey,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.recentLocations.length,
                itemBuilder: (BuildContext context, int index) {
                  final location = controller.recentLocations[index];
                  return recentLocationList(location, context);
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 16.kw, vertical: 16.kh),
        ));
  }
}
