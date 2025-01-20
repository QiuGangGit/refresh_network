import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../request/base_response.dart';
import '../route.dart';
import '../serivice/api_service.dart';

class SplashLogic extends GetxController {
  late AndroidDeviceInfo androidInfo;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  String qrCodeUrl = ""; // 二维码的链接
  @override
  void onInit() {
    // TODO: implement onInit
    appAuthExpireCheck();
  }

  void appAuthExpireCheck() async {
    //获取设备二维码
    await getDeviceInfo();
    BaseResponse? baseResponse = await ApiService.appAuthExpireCheck(qrCodeUrl);
    if (baseResponse?.code == 0) {
      Get.offAndToNamed(Routes.login);
    } else {
      Get.offAndToNamed(Routes.login);
      Fluttertoast.showToast(
        msg: baseResponse?.msg ?? "没有权限或发生错误",
        toastLength: Toast.LENGTH_SHORT,
        // 可以是 SHORT 或 LONG
        gravity: ToastGravity.BOTTOM,
        // 位置，可以是 TOP, BOTTOM 或 CENTER
        timeInSecForIosWeb: 1,
        // 对于 iOS 或 Web 应用，Toast 持续时间（秒）
        backgroundColor: Colors.black,
        // 背景色
        textColor: Colors.white,
        // 文本颜色
        fontSize: 16.0, // 字体大小
      );
    }
  }

  // 模拟生成二维码链接
  Future<void> getDeviceInfo() async {
    try {
      // 获取设备信息
      if (Platform.isAndroid) {
        androidInfo = await _deviceInfoPlugin.androidInfo;
        qrCodeUrl = androidInfo.id +
            androidInfo.brand +
            androidInfo.hardware +
            androidInfo.fingerprint;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('qrCodeUrl', qrCodeUrl); // 存储字符串
        update();
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }
}
