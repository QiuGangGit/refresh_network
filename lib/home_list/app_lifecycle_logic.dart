import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:refresh_network/request/base_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../serivice/api_service.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  // 在这里定义应用生命周期事件
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addObserver(this); // 添加生命周期监听器
  }

  @override
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this); // 移除生命周期监听器
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // 当应用进入后台或被销毁时，发送离线请求
      print('App is offline');
      sendOffline();
      // 在这里执行你的离线操作，例如发送请求到后台
    }
  }

  void sendOffline() async {
    final prefs = await SharedPreferences.getInstance();
    String? qrCodeUrl = prefs.getString('qrCodeUrl') ?? "";
    BaseResponse? baseResponse =
        await ApiService.appHotelDeviceOnline(qrCodeUrl, "0");
    if (baseResponse?.code == 0) {
      print("------------设备离线了");
    } else {
      print("------------${baseResponse?.msg}");
    }
  }
}
