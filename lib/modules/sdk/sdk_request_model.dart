class SdkRequestModel {
  SdkRequestModel({
    this.merchantKey = "",
    this.secretKey = "",
    this.documentNumber = "",
    this.apiKey = "",
    this.isProd = false,
  });

  final String merchantKey;
  final String secretKey;
  final String documentNumber;
  final String apiKey;
  final bool isProd;

  factory SdkRequestModel.fromJson(Map<String, dynamic> json) {
    return SdkRequestModel(
      merchantKey: json["merchantKey"] ?? "",
      secretKey: json["secretKey"] ?? "",
      documentNumber: json["CCCD"] ?? "",
      apiKey: json["apiKey"] ?? "",
      isProd: json["isProd"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "merchantKey": merchantKey,
        "secretKey": secretKey,
        "apiKey": apiKey,
        "CCCD": documentNumber,
        "isProd": isProd,
      };
}
