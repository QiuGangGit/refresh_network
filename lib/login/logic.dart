import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../route.dart';

class LoginLogic extends GetxController {
  String qrCodeUrl = ""; // 二维码的链接
  Timer? loginCheckTimer; // 定时器
  bool isLoggedIn = false; // 登录状态

  @override
  void onInit() {
    super.onInit();
    generateQrCode();
    startLoginStatusCheck();
  }

  @override
  void onClose() {
    loginCheckTimer?.cancel();
    super.onClose();
  }

  // 模拟生成二维码链接
  Future<void> generateQrCode() async {
    try {
      // 替换为实际接口
      final response = await http.get(Uri.parse('https://example.com/api/getQrCode'));
      if (response.statusCode == 200) {
        qrCodeUrl = jsonDecode(response.body)['qrCodeUrl'];
      } else {
        qrCodeUrl = "Error generating QR Code";
      }
      update(); // 通知 UI 更新
    } catch (e) {
      qrCodeUrl = "Error fetching QR Code: $e";
      update();
    }
  }

  // 开始轮询登录状态
  void startLoginStatusCheck() {
    loginCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        // 替换为实际接口
        final response = await http.get(Uri.parse('https://example.com/api/checkLoginStatus'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'loggedIn') {
            isLoggedIn = true;
            update();
            loginCheckTimer?.cancel();
            onLoginSuccess();
          }
        }
      } catch (e) {
        print("Error checking login status: $e");
      }
    });
  }

  // 登录成功跳转到主页面
  void onLoginSuccess() {
    Get.offAndToNamed(Routes.home);
  }
}
