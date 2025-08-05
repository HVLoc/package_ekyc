import 'package:flutter/material.dart';
import 'package:package_ekyc/core/router/app_router.src.dart';
import 'package:package_ekyc/modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';
import 'package:package_ekyc/modules/sdk/sdk.src.dart';
import 'package:package_ekyc/package_ekyc.dart';
import 'package:package_ekyc/shares/shares.src.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      // initialRoute: AppRoutes.initApp,
      getPages: RouteAppPage.route,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // translationsKeys: AppTranslation.translations,
      locale: const Locale('vi', 'VN'),

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng dụng NFC và EKYC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Gọi hàm đọc NFC khi nhấn nút
                  await PackageEkyc.readOnlyNFC().then((onValue) {
                    if (onValue is SendNfcRequestModel) {
                      SendNfcRequestModel sendNfcRequestModel = onValue;
                      print(
                          'NFC(${DateTime.now()}): ${sendNfcRequestModel.toJsonFull()}');
                    }
                  });
                },
                child: const Text('Đọc NFC'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Gọi hàm kiểm tra EKYC khi nhấn nút
                  SdkRequestModel sdkRequestModel = SdkRequestModel(
                    merchantKey: "",
                    secretKey: "",
                    method: "INTEGRITY", // INTEGRITY, C06
                    apiKey: "",
                    isProd: false,
                  );
                  await PackageEkyc.checkEKYC(
                    sdkRequestModel,
                  ).then((onValue) {
                    if (onValue is SendNfcRequestModel) {
                      SendNfcRequestModel sendNfcRequestModel = onValue;
                      print(
                          'EKYC(${DateTime.now()}): ${sendNfcRequestModel.toJsonFull()}');
                    }
                  });
                },
                child: const Text('Xác thực EKYC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
