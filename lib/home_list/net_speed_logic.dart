import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

mixin NetSpeedLogic on GetxController {
  var downloadSpeed = 0.0.obs; // 下载速度，单位KB/s
  var isBuffering = false.obs; // 是否缓冲
  var totalDownloadedBytes = 0; // 累积的字节数
  var startTime = DateTime.now(); // 记录开始的时间
  @override
  void onInit() {
    super.onInit();
  }

  // 下载速度阈值，低于此值则认为加载缓慢
  double downloadSpeedThreshold = 0.5;

  // 每秒计算一次下载速度
  void startSpeedCalculation() {
    if (!isBuffering.value) {
      isBuffering.value = true;
      totalDownloadedBytes = 0; // 重置已下载字节数
      startTime = DateTime.now();

      // 启动定时器，计算下载速度
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (isBuffering.value) {
          calculateDownloadSpeed();
        } else {
          timer.cancel();
        }
      });
    }
  }

  // 停止计算下载速度
  void stopSpeedCalculation() {
    isBuffering.value = false;
  }

  // 计算下载速度
  void calculateDownloadSpeed() {
    final currentTime = DateTime.now();
    if (currentTime.difference(startTime).inSeconds >= 1) {
      double downloadSpeedKB = totalDownloadedBytes / 1024.0; // 转换为 KB/s
      downloadSpeed.value = downloadSpeedKB;

      // 如果下载速度低于某个阈值，警告
      if (downloadSpeedKB < downloadSpeedThreshold) {
        print("Warning: Video loading slowly");
      }

      // 重置累计字节数和起始时间
      totalDownloadedBytes = 0;
      startTime = currentTime;
    }
  }

  // 更新已下载字节数
  void updateDownloadedBytes(int bytes) {
    totalDownloadedBytes += bytes;
  }
}
