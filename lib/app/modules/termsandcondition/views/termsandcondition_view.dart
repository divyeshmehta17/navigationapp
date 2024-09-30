import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customappbar.dart';

import '../controllers/termsandcondition_controller.dart';

class TermsandconditionView extends GetView<TermsandconditionController> {
  const TermsandconditionView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Terms Of Use'),
      body: Center(
        child: Text(
          'TermsandconditionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
