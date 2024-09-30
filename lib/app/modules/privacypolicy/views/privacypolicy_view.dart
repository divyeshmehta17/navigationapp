import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/privacypolicy_controller.dart';

class PrivacypolicyView extends GetView<PrivacypolicyController> {
  const PrivacypolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrivacypolicyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PrivacypolicyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
