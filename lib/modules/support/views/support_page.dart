import 'package:flutter/material.dart';
import 'package:package_ekyc/assets.dart';
import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/generated/locales.g.dart';
import 'package:package_ekyc/modules/support/support.src.dart';

import '../../../../shares/shares.src.dart';

part 'support_view.dart';

class SupportPage extends BaseGetWidget<SupportController> {
  const SupportPage({super.key});

  @override
  SupportController get controller => Get.put(SupportController());

  @override
  Widget buildWidgets(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: AppColors.basicWhite,
      appBar: BackgroundAppBar.buildAppBar(
        LocaleKeys.support_title.tr,
        isColorGradient: false,
        centerTitle: false,
        leading: true,
        backgroundColor: AppColors.basicWhite,
      ),
      body: baseShowLoading(
        () => SizedBox(
            height: Get.height, width: Get.width, child: _itemBody(controller)),
      ),
    );
  }
}
