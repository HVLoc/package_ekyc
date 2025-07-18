import 'package:cached_network_image/cached_network_image.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/shares/shares.src.dart';
import 'package:flutter/material.dart';

class SDSImageNetwork extends StatelessWidget {
  final SDSImageNetworkModel sdsImageNetworkModel;

  const SDSImageNetwork(
    this.sdsImageNetworkModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (sdsImageNetworkModel.imgUrl.isNullOrEmpty) {
      return ClipRRect(
        borderRadius: sdsImageNetworkModel.borderRadius ??
            BorderRadius.circular(
              AppDimens.padding8,
            ),
        child: SizedBox(
          width: sdsImageNetworkModel.width,
          height: sdsImageNetworkModel.height,
          child: sdsImageNetworkModel.errorWidget ??
              ImageWidget.imageAsset(
                sdsImageNetworkModel.imageDefault,
                fit: BoxFit.cover,
                width: sdsImageNetworkModel.width,
              ),
        ),
      );
    }
    String imageUrl = sdsImageNetworkModel.imgUrl!;
    // if (sdsImageNetworkModel.isAddBaseUrl) {
    //   imageUrl = EnvSwitcher.getBaseUrl() + sdsImageNetworkModel.imgUrl!;
    // }
    return ClipRRect(
      borderRadius: sdsImageNetworkModel.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: sdsImageNetworkModel.fit,
        width: sdsImageNetworkModel.width,
        height: sdsImageNetworkModel.height,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          );
        },
        errorWidget: (context, error, stackTrace) {
          return sdsImageNetworkModel.errorWidget ??
              ImageWidget.imageAsset(
                sdsImageNetworkModel.imageDefault,
                width: sdsImageNetworkModel.width,
              );
        },
      ),
    );
  }
}
