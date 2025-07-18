import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/generated/locales.g.dart';
import 'package:package_ekyc/modules/authentication_kyc/verify_profile_ca/verify_profile_ca_src.dart';
import 'package:package_ekyc/shares/shares.src.dart';

mixin LoginCaController {
  void initTextEditing(VerifyProfileController controller) {
    controller.userNameFocus.value.addListener(() {
      if (controller.userNameFocus.value.hasFocus) {
        controller.fillColorUserName.value = AppColors.secondaryNavyPastel;
      } else {
        controller.fillColorUserName.value = AppColors.basicWhite;
      }
    });
    controller.passwordFocus.value.addListener(() {
      if (controller.passwordFocus.value.hasFocus) {
        controller.fillColorPassword.value = AppColors.secondaryNavyPastel;
      } else {
        controller.fillColorPassword.value = AppColors.basicWhite;
      }
    });
  }

  // Lấy dữ liệu từ hive về textEditing
  void initTextHive(VerifyProfileController controller) {
    LoginCaRequestModel loginCaRequestModel =
        hiveUserLogin.get(AppKey.keyRememberLoginCa) ??
            LoginCaRequestModel(
              userName: "",
              password: "",
              isRememberMe: false,
              isBiometric: false,
            );
    controller.textUserName.text = loginCaRequestModel.userName;
    controller.textPassword.text = loginCaRequestModel.password;
    controller.isRememberLogin.value = loginCaRequestModel.isRememberMe;
  }

  Future<void> confirmLoginCa(VerifyProfileController controller) async {
    bool isLoginSuccess =
        await loginCa(controller).whenComplete(() => controller.hideLoading());
    if (isLoginSuccess) {
      await controller.getAuthProfile();
    }
  }

  Future<bool> loginCa(VerifyProfileController controller) async {
    bool isLoginSuccess = false;

    KeyBoard.hide();
    if (controller.formKey.currentState?.validate() ?? false) {
      try {
        controller.showLoading();
        LoginCaRequestModel loginCaRequestModel = LoginCaRequestModel(
          userName: controller.textUserName.text.trim(),
          password: controller.textPassword.text.trim(),
          isRememberMe: false,
          isBiometric: false,
        );
        BaseResponseBE baseResponseBE = await controller.loginCaRepository
            .loginAppRepository(loginCaRequestModel);
        // if (baseResponseBE.success == EnumStatusResponse.success) {
        //   LoginCaResponseModel loginCaResponseModel = baseResponseBE.data;
        //   controller.uIdCa = loginCaResponseModel.userId;
        //   hiveApp.put(AppKey.keyToken, "Bearer ${loginCaResponseModel.token}");
        //   isLoginSuccess = true;
        //   saveAccUser(controller, loginCaRequestModel);
        // } else {
        //   controller.showSnackBar(baseResponseBE.message);
        // }
      } catch (e) {
        controller.hideLoading();
        controller.showFlushNoti(
          LocaleKeys.registerCa_loginFalse.tr,
          type: FlushBarType.error,
        );
      }
    }
    return isLoginSuccess;
  }

  void saveAccUser(VerifyProfileController controller,
      LoginCaRequestModel loginCaRequestModel) {
    if (controller.isRememberLogin.isTrue) {
      loginCaRequestModel.isRememberMe = true;
      hiveUserLogin.put(AppKey.keyRememberLoginCa, loginCaRequestModel);
    } else {
      hiveUserLogin.clear();
    }
  }
}
