import 'package:flutter/material.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/shares/shares.src.dart';

class ButtonUtils {
  static DateTime? _dateTime;
  static int _oldFunc = 0;

  /// Sử dụng để tránh trường hợp click liên tiếp khi thực hiện function
  static Widget baseOnAction({
    required Function onTap,
    required Widget child,
    bool isContinuous = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isContinuous) {
          onTap();
        } else {
          DateTime now = DateTime.now();
          if (_dateTime == null ||
              now.difference(_dateTime ?? DateTime.now()) > 2.seconds ||
              onTap.hashCode != _oldFunc) {
            _dateTime = now;
            _oldFunc = onTap.hashCode;
            onTap();
          }
        }
      },
      child: child,
    );
  }

  static void onTapButton({required Function onTap, required bool isLoading}) {
    if (!isLoading) {
      DateTime now = DateTime.now();
      if (_dateTime == null ||
          now.difference(_dateTime ?? DateTime.now()) > 2.seconds ||
          onTap.hashCode != _oldFunc) {
        _dateTime = now;
        _oldFunc = onTap.hashCode;
        onTap();
      }
    }
  }

  static Widget buildButton(
    String btnTitle,
    Function function, {
    List<Color> colors = AppColors.primaryMain,
    Color? backgroundColor,
    bool isLoading = false,
    bool showLoading = true,
    bool isCenterButton = true,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? height,
    Color? colorText,
    BorderRadiusGeometry? borderRadius,
    Border? border,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? AppDimens.btnMedium,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border ?? const Border(),
        gradient:
            backgroundColor != null ? null : LinearGradient(colors: colors),
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimens.radius8),
      ),
      child: ElevatedButton(
        onPressed: () => onTapButton(isLoading: isLoading, onTap: function),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          foregroundColor: AppColors.colorTransparent,
          backgroundColor: AppColors.colorTransparent,
          shadowColor: AppColors.colorTransparent,
          shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(AppDimens.radius8)),
        ),
        child: Stack(
          children: [
            if (icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            (isCenterButton && isLoading && showLoading)
                ? const SizedBox()
                : Center(
                    child: TextUtils(
                      text: btnTitle,
                      availableStyle: StyleEnum.subBold,
                      color: colorText ?? AppColors.basicWhite,
                    ),
                  ),
            Align(
              alignment:
                  isCenterButton ? Alignment.center : Alignment.centerRight,
              child: Visibility(
                visible: isLoading && showLoading,
                child: const SizedBox(
                  height: AppDimens.btnSmall,
                  width: AppDimens.btnSmall,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: AppColors.basicWhite,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).paddingOnly(
      bottom: GetPlatform.isAndroid ? 0 : AppDimens.padding10,
    );
  }

  static Widget baseButton(
    Function? function,
    String text, {
    Color? colorText,
  }) {
    return baseOnAction(
        onTap: () {
          ShowDialog.dismissDialog();

          function?.call();
        },
        child: TextButton(
          onPressed: null,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: TextUtils(
            text: text,
            availableStyle: StyleEnum.bodyRegular,
            color: colorText ?? AppColors.colorBlack,
          ),
        ));
  }
}
