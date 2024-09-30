import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
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
    String incidentType = '';
    String location = '123 Street, Las Vegas, Nevada';
    String details = '';

    return Scaffold(
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
                  items: ['Theft', 'Vandalism', 'Accident', 'Other']
                      .map((incident) => DropdownMenuItem<String>(
                            value: incident,
                            child: Text(incident),
                          ))
                      .toList(),
                  onChanged: (value) {
                    incidentType = value!;
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
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    suffixIcon: const Icon(Icons.mic),
                  ),
                  initialValue: location,
                  onChanged: (value) {
                    location = value;
                  },
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    // Handle use current location action
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text('Use Current Location'),
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
                    controller.postCreatePost(
                        typeOfIncident: 'Car crash',
                        latitude: 40.712776,
                        longitude: -74.005974,
                        type: "Point",
                        addressLine: "123 Main St, New York, NY 10001",
                        description: controller.descriptioncontroller.text,
                        key: controller.profileimage.value!.files![0]!.key
                            .toString(),
                        url: controller.profileimage.value!.files![0]!.url
                            .toString());
                    if (formKey.currentState!.validate()) {
                      // final newReport = IncidentReport(
                      //   type: incidentType,
                      //   location: location,
                      //   dummyname: 'dummyname',
                      //   details: details,
                      //   imagePath: controller.imageFile.value?.path ?? '',
                      //   time: DateTime.now(),
                      // );
                      // controller.addIncidentReport(newReport);

                      // Get.offNamed(Routes.COMMUNITY);
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
