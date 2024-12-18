import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/customwidgets/buildLocationInputField.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/navigationAppButton.dart';
import '../../../services/text_style_util.dart';
import '../controllers/reportincident_controller.dart';

class ReportincidentView extends GetView<ReportincidentController> {
  const ReportincidentView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String location = '123 Street, Las Vegas, Nevada';
    String details = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Report Incident',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Type of incident',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  items: controller.incidentTypes
                      .map((incident) => DropdownMenuItem<String>(
                            value: incident['type'] as String,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: incident['color'] as Color,
                                  child: CommonImageView(
                                    svgPath: incident['icon'] as String,
                                    svgColor: Colors.white,
                                    height: 20.kh,
                                    width: 20.kh,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(incident['type'] as String),
                              ],
                            ),
                          ))
                      .toList(),
                  value: controller.selectedIncidentType.value.isNotEmpty
                      ? controller.selectedIncidentType.value
                      : null, // Set initial value if preselected
                  onChanged: (value) {
                    controller.selectedIncidentType.value = value!;
                  },
                  validator: (value) =>
                      value == null ? 'Please select an incident type' : null,
                  hint: const Text('Select type of incident'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                buildLocationInputField(
                  controller: controller.searchcontroller,
                  itemClick: (Prediction) {
                    controller.selectedLocation.value =
                        Prediction.description!.toString();
                    controller.searchcontroller.text = Prediction.description!;
                  },
                  context: context,
                  focusNode: FocusNode(),
                  inputDecoration: InputDecoration(
                      hintText: 'Enter Your Destination',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: context.darkGrey),
                          borderRadius: BorderRadius.circular(12.kw))),
                  color: Colors.white,
                  textColor: context.darkGrey,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => controller.isLoading.value
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
                      : TextButton.icon(
                          onPressed: () {
                            controller.getCurrentLocation();
                          },
                          icon: const Icon(Icons.my_location),
                          label: const Text('Use Current Location'),
                        ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Provide incident details.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.descriptioncontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    hintText: 'Add description...',
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    details = value;
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          controller.pickImage();
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Upload Image/Video (optional)'),
                      ),
                      if (controller.selectedImage.value != null)
                        Image.file(
                          File(controller.selectedImage.value!.path),
                          height: 200,
                        ),
                    ],
                  );
                }),
                NavigationAppButton(
                  label: 'Submit',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final profileImageKey =
                          controller.profileimage.value?.files?[0]?.key;
                      final profileImageUrl =
                          controller.profileimage.value?.files?[0]?.url;
                      print(profileImageUrl);
                      controller.postCreatePost(
                        typeOfIncident: controller.selectedIncidentType.value,
                        latitude: 40.712776,
                        longitude: -74.005974,
                        type: "Point",
                        addressLine: controller.selectedLocation.value,
                        description: controller.descriptioncontroller.text,
                        key: profileImageKey ??
                            '', // Provide an empty string if no image
                        url: profileImageUrl ??
                            '', // Provide an empty string if no image
                      );
                    }
                  },
                  color: context.brandColor1,
                  textStyle: TextStyleUtil.poppins600(
                      fontSize: 16.kh, color: Colors.white),
                  leadinglabelpadding: EdgeInsets.symmetric(vertical: 12.kh),
                  borderRadius: BorderRadius.circular(48.kw),
                ).paddingOnly(top: 20.kh),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
