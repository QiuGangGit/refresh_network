import 'package:flutter/material.dart';
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
            onTap: (){
              controller.onLoginSuccess();
            },
            child: Center(
              child: controller.isLoggedIn
                  ? CircularProgressIndicator() // 显示登录状态
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.qrCodeUrl.isEmpty || controller.qrCodeUrl.startsWith("Error")
                      ? Text(controller.qrCodeUrl) // 显示错误信息
                      : QrImageView(
                    data: controller.qrCodeUrl,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Use your phone to scan the QR code to log in.",
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