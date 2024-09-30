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
        title: 'Saved Routes',
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.offlineRoutes.length,
          itemBuilder: (context, index) {
            final route = controller.offlineRoutes[index];
            return Column(
              children: [
                ListTile(
                  title: Text(
                    route['title'].toString(),
                    style: TextStyleUtil.poppins500(fontSize: 14.kh),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${route['routesSaved']} routes saved',
                        style: TextStyleUtil.poppins400(fontSize: 12.kh),
                      ),
                      Text(
                        route['distance'].toString(),
                        style: TextStyleUtil.poppins400(fontSize: 12.kh),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Handle more options here
                    },
                  ),
                ),
                const Divider()
              ],
            );
          },
        );
      }),
    );
  }
}
