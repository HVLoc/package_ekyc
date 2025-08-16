import 'package:flutter/material.dart';
import 'package:package_ekyc/core/router/app_router.src.dart';
import 'package:package_ekyc/generated/locales.g.dart';
import 'package:package_ekyc/modules/authentication_kyc/nfc_kyc/nfc_kyc.src.dart';
import 'package:package_ekyc/package_ekyc.dart';
import 'package:package_ekyc/shares/shares.src.dart';
import 'package:package_ekyc/shares/widgets/form/base_form_login.dart';

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
      getPages: RouteAppPage.route,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: const Locale('vi', 'VN'),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cccdController = TextEditingController();

  @override
  void dispose() {
    _cccdController.dispose();
    super.dispose();
  }

  Future<void> _readNFC() async {
    KeyBoard.hide();

    /// Lấy số CCCD từ ô nhập
    String cccd = _cccdController.text.trim();

    /// Gọi hàm NFC với documentNumber
    await PackageEkyc.readOnlyNFC(
      documentNumber: cccd,
    ).then((onValue) {
      if (onValue is SendNfcRequestModel) {
        SendNfcRequestModel sendNfcRequestModel = onValue;
        debugPrint(
            'NFC(${DateTime.now()}): ${sendNfcRequestModel.toJsonFull()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng dụng demo NFC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Ô nhập số CCCD
              TextField(
                controller: _cccdController,
                decoration: const InputDecoration(
                  labelText: "Nhập số căn cước công dân",
                  border: OutlineInputBorder(),
                ),
                maxLength: 12,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              ButtonUtils.buildButton(
                'Đọc NFC',
                _readNFC,

                // borderRadius: BorderRadius.circular(AppDimens.radius4),
                // height: AppDimens.iconHeightButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
