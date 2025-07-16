import 'package:package_ekyc/assets.dart';
import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/const.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';

import '../../shares/shares.src.dart';
import 'modules/sdk/sdk.src.dart';

class PackageEkyc {
  static Future<SendNfcRequestModel?> readOnlyNFC({
    GuidNFC? guidNFC,
  }) async {
    Get.toNamed(AppRoutes.initApp);
    AppController appController = Get.put(AppController());

    appController.isOnlyNFC = true;
    appController.guidNFC = guidNFC;

    Assets.isFromModules = true;
    var result = await appController.checkPermissionApp();
    Get.back();
    Get.delete<AppController>();
    return result;
  }

  static Future<SendNfcRequestModel?> checkEKYC(
    SdkRequestModel sdkRequestModel, {
    GuidNFC? guidNFC,
  }) async {
    Get.toNamed(AppRoutes.initApp);
    AppController appController = Get.put(AppController());
    // Assets.isFromModules = true;
    appController.sdkModel = sdkRequestModel;
    appController.guidNFC = guidNFC;
    AppConstSDK.apiKey = appController.sdkModel.apiKey;
    var result = await appController.checkPermissionApp();
    Get.back();
    Get.delete<AppController>();
    return result;
  }
}
