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
      Get.toNamed(Routes.home);
    } else {
      if(baseResponse?.msg=="设备授权已到期"){
        Fluttertoast.showToast( msg: baseResponse?.msg??'', toastLength: Toast.LENGTH_LONG,);
        return;
      }
      Get.toNamed(Routes.login);
    }
  }

  // 模拟生成二维码链接
  Future<void> getDeviceInfo() async {
    try {
      // 获取设备信息
      if (Platform.isAndroid) {
        androidInfo = await _deviceInfoPlugin.androidInfo;
        qrCodeUrl = androidInfo.device;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('qrCodeUrl', qrCodeUrl); // 存储字符串
        await prefs.setString('brand', androidInfo.brand); // 存储字符串
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }
}
