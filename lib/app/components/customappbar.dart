import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../services/text_style_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTile;
  final List<Widget>? actions;
  final Widget? leading;
  const CustomAppBar(
      {super.key, this.title, this.centerTile, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      elevation: 0.5,
      title: Text(
        title ?? '',
        style: TextStyleUtil.poppins500(fontSize: 16.kh),
      ),
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.back();
            },
          ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
