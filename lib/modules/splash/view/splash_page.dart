import 'package:flutter/material.dart';
import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/shares/shares.src.dart';

class SplashPage extends GetView<AppController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(AppController(), permanent: true);
    return Container(
      color: AppColors.basicGrey4,
      alignment: Alignment.center,
      child: const Center(
        child: FlutterLogo(
          size: 100,
        ),
      ),
    );
  }
}
