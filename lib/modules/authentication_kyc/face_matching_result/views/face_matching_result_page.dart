import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_ekyc/assets.dart';
import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/generated/locales.g.dart';
import 'package:package_ekyc/modules/authentication_kyc/face_matching_result/face_matching_result.src.dart';
import 'package:package_ekyc/shares/package/export_package.dart';

import '../../../../shares/widgets/widgets.src.dart';

part 'face_matching_result_view.dart';

class FaceMatchingResultPage
    extends BaseGetWidget<FaceMatchingResultController> {
  const FaceMatchingResultPage({super.key});

  @override
  FaceMatchingResultController get controller =>
      Get.put(FaceMatchingResultController());

  @override
  Widget buildWidgets(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: AppColors.basicWhite,
      appBar: BackgroundAppBar.buildAppBar(
        LocaleKeys.live_ness_result_appbar.tr,
        isColorGradient: false,
        leading: true,
        backgroundColor: AppColors.basicWhite,
      ),
      body: baseShowLoading(
        () => SizedBox(
            height: Get.height, width: Get.width, child: _itemBody(controller)),
      ),
      // bottomSheet: Column(
      //   children: [
      //     ButtonUtils.buildButton(LocaleKeys.home_agree.tr, () async {
      //       Get.toNamed(AppRoutes.routeQrKyc);
      //     },
      //         isLoading: controller.isShowLoading.value,
      //         backgroundColor: AppColors.primaryBlue1,
      //         colorText: AppColors.basicWhite),
      //     sdsSB5,
      //   ],
      // ),
    );
  }
}
