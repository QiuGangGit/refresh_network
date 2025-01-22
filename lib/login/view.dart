import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'logic.dart';

class LoginPage extends StatelessWidget {
  final LoginLogic controller = Get.put(LoginLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginLogic>(
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              controller.onLoginSuccess();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: controller.miniProgramUrl,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 20.w),
                  const Text(
                    "使用微信扫描二维码登录",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
