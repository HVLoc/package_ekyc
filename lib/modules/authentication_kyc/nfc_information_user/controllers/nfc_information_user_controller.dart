import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/generated/locales.g.dart';
import 'package:package_ekyc/modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';
import 'package:package_ekyc/modules/sdk/sdk.src.dart';
import 'package:package_ekyc/shares/utils/time/date_utils.dart';

import '../../../../shares/shares.src.dart';

class NfcInformationUserController extends BaseGetxController {
  // String? idDocument = '';
  // String? firstName = '';
  // String? lastName = '';

  // String? gender;
  // String? nationality;
  String? dateOfBirth;
  String? dateOfExpiry;
  String? image;
  String? imageBody;
  bool authenticationSuccess = false;
  bool successSDK = false;
  String packageKind = AppConst.typeSanbox;
  RxBool authenticationVisible = false.obs;
  SendNfcRequestModel sendNfcRequestModel = SendNfcRequestModel();
  AppController appController = Get.find<AppController>();
  late NfcRepository nfcRepository;

  @override
  void onInit() {
    setupData();
    super.onInit();
  }

  Future<void> setupData() async {
    nfcRepository = NfcRepository(this);

    if (Get.arguments != null) {
      /*if (Get.arguments[1] is DataOcrModel) {
        dataOcrModel = Get.arguments[1];
      }*/
      if (Get.arguments is SendNfcRequestModel) {
        sendNfcRequestModel = Get.arguments;
        // idDocument = sendNfcRequestModel.number;
        // firstName = sendNfcRequestModel.nameVNM;
        // lastName = sendNfcRequestModel.lastName;
        // gender = sendNfcRequestModel.sexVMN /*== "M"
        //     ? LocaleKeys.nfcInformationUserPage_sexM.tr
        //     : LocaleKeys.nfcInformationUserPage_sexF.tr*/;
        if (sendNfcRequestModel.isView) {
          dateOfBirth = sendNfcRequestModel.dob;
          dateOfExpiry = sendNfcRequestModel.doe;
        } else {
          dateOfBirth = convertDateToString(
            convertStringToDate(
              sendNfcRequestModel.dob,
              pattern5,
            ),
            pattern1,
          );
          dateOfExpiry = convertDateToString(
            convertStringToDate(
              sendNfcRequestModel.doe,
              pattern5,
            ),
            pattern1,
          );
        }

        // nationality = sendNfcRequestModel.nationVNM;
        image = sendNfcRequestModel.file;
        imageBody = sendNfcRequestModel.bodyFileId;
        packageKind = sendNfcRequestModel.kind ?? AppConst.typeProduction;

        // if (appController.typeAuthentication == AppConst.typeAuthentication) {
        //   await nfcRepository
        //       .sendNfcRepository(sendNfcRequestModel)
        //       .then((value) {
        //     authenticationSuccess = value.status;
        //     authenticationVisible.value = true;
        //   });
        // }
        appController.sendNfcRequestGlobalModel = sendNfcRequestModel;

        if (sendNfcRequestModel.isFaceMatching ?? false) {
          successSDK = true;
          // authenticationFake();
          authenticationSDK();
        }
      }
    }
  }

  void authenticationFake() async {
    authenticationSuccess = true;
    authenticationVisible.value = true;
  }

  // Future<void> authentication(String id, String bodyFileId) async {
  //   sendNfcRequestModel.fileId = id;
  //   sendNfcRequestModel.bodyFileId = bodyFileId;
  //   await nfcRepository.sendNfcRepository(sendNfcRequestModel).then((value) {
  //     authenticationSuccess = value.data?.result ?? false;
  //     authenticationVisible.value = true;
  //     packageKind = value.data?.packageKind ?? AppConst.typeSanbox;

  //     if (Get.isRegistered<OverviewController>()) {
  //       OverviewController overviewController = Get.find<OverviewController>();
  //       overviewController.getUserInfo();
  //     }
  //   });
  // }

  Future<void> authenticationSDK() async {
    // sendNfcRequestModel.fileId = id;
    // sendNfcRequestModel.bodyFileId = bodyFileId;
    try {
      showLoadingOverlay();
      SdkRequestAPI sdkRequestAPI = CreatePararmSDK.sdkRequestAPI(
        appController.sdkModel,
        sendNfcRequestModel,
      );
      await nfcRepository
          .sendNfcVerify(
        sendNfcRequestModel,
        sdkRequestAPI,
        appController.sdkModel.isProd,
      )
          .then((value) {
        if (value.status) {
          authenticationSuccess = value.data?.result == true;
          authenticationVisible.value = value.data?.result == true;
          sendNfcRequestModel.verifySignatureData = value.data;
          sendNfcRequestModel.statusSuccess = authenticationSuccess;

          appController.sendNfcRequestGlobalModel = sendNfcRequestModel;
        } else {
          ShowDialog.showDialogNotification(
            value.errors != null && value.errors!.isNotEmpty
                ? value.errors?.first.message?.vn ?? ""
                : LocaleKeys.live_ness_matchingFailContent.tr,
            confirm: () {
              Get.back();
            },
            title: LocaleKeys.live_ness_matchingFailContent.tr,
            titleButton: LocaleKeys.dialog_close.tr,
          );
        }
      });
    } finally {
      hideLoadingOverlay();
    }
  }

  // void returnToNative() {
  //   if (appController.isOnlyNFC) {
  //     SystemNavigator.pop();
  //   }
  //   appController.sendDataToNative();
  // }

  void returnToModule() {
    appController.sendDataToModulesEkyc();
  }

  Future<void> goPage() async {
    print("isOnlyNFC KYC=>>>>> ${appController.isOnlyNFC}");
    if (successSDK || appController.isOnlyNFC) {
      returnToModule();
    } else {
      Get.offNamed(AppRoutes.routeLiveNessKyc);
    }
    // if (appController.typeAuthentication == AppConst.typeRegister) {
    //   Get.toNamed(AppRoutes.routeRegisterInfo);
    // } else if (appController.typeAuthentication == AppConst.typeForgotPass) {
    //   await Biometrics().authenticate(
    //       // localizedReasonStr: "Quý khách vui lòng quét vân tay hoặc khuôn mặt để xác thực",
    //       onDeviceUnlockUnavailable: () async {
    //     // await gotoPage();
    //     Get.toNamed(AppRoutes.routeForgotPass);
    //   }, onAfterLimit: () {
    //     Fluttertoast.showToast(
    //         msg: LocaleKeys.biometric_msgLimit.tr,
    //         toastLength: Toast.LENGTH_LONG);
    //   }).then((isAuthenticated) async {
    //     if (isAuthenticated ?? false) {
    //       // await gotoPage();
    //       Get.toNamed(AppRoutes.routeForgotPass);
    //     }
    //   });
    // } else if (appController.typeAuthentication ==
    //     AppConst.typeAuthentication) {
    //   Get.toNamed(AppRoutes.routeLiveNessKyc);
    // }

    // if (convertStringToDate(
    //       sendNfcRequestModel.doe,
    //       pattern5,
    //     )?.isAfter(DateTime.now()) ??
    //     true) {
    //   showLoading();
    //   await nfcRepository.sendNfcRepository(sendNfcRequestModel);
    //   appController.sendNfcRequestGlobalModel = sendNfcRequestModel;
    //   hideLoading();
    //   Get.toNamed(
    //     AppRoutes.routeInstructLiveNessKyc,
    //   );
    //   // Get.toNamed(AppRoutes.routeAwaitOCRData);
    // } else {
    //   if (appController.configCertificateModel.isCreateCertificate) {
    //     if (Get.isRegistered<RegisterAccountController>()) {
    //       Get.until(
    //           (route) => route.settings.name == AppRoutes.routeRegisterAccount);
    //     }
    //   } else {
    //     if (Get.isRegistered<VerifyProfileController>()) {
    //       Get.until(
    //           (route) => route.settings.name == AppRoutes.routeVerifyProfile);
    //     }
    //   }
    //   showSnackBar(LocaleKeys.nfc_nfc_expired_message.tr);
    // }
  }

  Future<void> gotoPage() async {
    if (appController.typeAuthentication == AppConst.typeRegister) {
      Get.toNamed(AppRoutes.routeRegisterInfo);
    } else if (appController.typeAuthentication == AppConst.typeForgotPass) {
      Get.toNamed(AppRoutes.routeForgotPass);
    } else if (appController.typeAuthentication ==
        AppConst.typeAuthentication) {
      Get.toNamed(AppRoutes.routeLiveNessKyc);
    }
  }
}
