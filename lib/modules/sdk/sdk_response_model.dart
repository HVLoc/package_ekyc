import 'package:package_ekyc/modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';
import 'package:package_ekyc/modules/login/login.src.dart';

class SdkResponseModel {
  final UserInfoModel userInfoModel;
  final SendNfcRequestModel sendNfcRequestModel;
  SdkResponseModel(
      {required this.userInfoModel, required this.sendNfcRequestModel});

  Map<String, dynamic> toJson() => {
        "userInfoModel": userInfoModel.toJson(),
        "sendNfcModel": sendNfcRequestModel.toJson(),
      };
}
