import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Routes',
          style: TextStyleUtil.poppins500(fontSize: 18.kh),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.getsavedRoutes.value == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount:
                    controller.getsavedRoutes.value!.data!.results!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      titleTextStyle: TextStyleUtil.poppins500(fontSize: 14.kh),
                      title: Text(
                          '${controller.getsavedRoutes.value!.data!.results![index]!.startName.toString()}→${controller.getsavedRoutes.value!.data!.results![index]!.endName.toString()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'approx ${(controller.getsavedRoutes.value!.data!.results![index]!.distance! / 1000).toStringAsFixed(2)} kms',
                            style: TextStyleUtil.poppins400(fontSize: 12.kh),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                       Get.bottomSheet(Container());
                        },
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
