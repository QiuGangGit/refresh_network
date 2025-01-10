import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:refresh_network/serivice/api_service.dart';

import '../route.dart';

class LoginLogic extends GetxController {
  String qrCodeUrl = ""; // 二维码的链接
  Timer? loginCheckTimer; // 定时器
  bool isLoggedIn = false; // 登录状态
  late AndroidDeviceInfo androidInfo;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  @override
  void onInit() {
    super.onInit();
    ApiService.appInit();
    ApiService.appChannelList("");
    //获取设备二维码
    getDeviceInfo();
    // onLoginSuccess();

  }

  @override
  void onClose() {
    loginCheckTimer?.cancel();
    super.onClose();
  }

  // 模拟生成二维码链接
  Future<void> getDeviceInfo() async {
    try {
      // 获取设备信息
      if (Platform.isAndroid) {
        androidInfo = await _deviceInfoPlugin.androidInfo;
        qrCodeUrl=androidInfo.id+androidInfo.brand+androidInfo.hardware+androidInfo.fingerprint;

      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }

  // 开始轮询登录状态
  void startLoginStatusCheck() {
    loginCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
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
