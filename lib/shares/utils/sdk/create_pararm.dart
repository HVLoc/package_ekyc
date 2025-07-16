import 'package:package_ekyc/modules/sdk/sdk.src.dart';
import 'package:package_ekyc/shares/utils/utils.src.dart';

import '../../../modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';

class CreatePararmSDK {
  static SdkRequestAPI sdkRequestAPI(
    SdkRequestModel sdkRequestModel,
    SendNfcRequestModel sendNfcRequestModel,
  ) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String transactionId = IdGenerator.randomIKey;

    String hash = VerificationUtils.buildRequestHash(
      sdkRequestModel.merchantKey,
      sdkRequestModel.secretKey,
      transactionId,
      timestamp,
      sendNfcRequestModel.dg1DataB64 ?? "",
    );

    SdkRequestAPI sdkRequestAPI = SdkRequestAPI(
      merchantKey: sdkRequestModel.merchantKey,
      transactionId: transactionId,
      timestamp: timestamp,
      hash: hash,
    );
    return sdkRequestAPI;
  }
}
