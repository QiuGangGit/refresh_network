import 'dart:async';
import 'package:better_player/src/video_player/video_player_platform_interface.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

mixin NetSpeedLogic on GetxController {
  double downloadSpeed = 0.0; // 下载速度，单位KB/s
  bool isBuffering = false; // 是否缓冲
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
    if (!isBuffering) {
      isBuffering = true;
      update();
      totalDownloadedBytes = 0; // 重置已下载字节数
      startTime = DateTime.now();

      // 启动定时器，计算下载速度
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (isBuffering) {
          calculateDownloadSpeed();
        } else {
          timer.cancel();
        }
      });

    }
  }

  // 停止计算下载速度
  void stopSpeedCalculation() {
    isBuffering = false;
    totalDownloadedBytes=0;
    update();
  }

  // 计算下载速度
  void calculateDownloadSpeed() {
    final currentTime = DateTime.now();
    if (currentTime.difference(startTime).inSeconds >= 1) {
      double downloadSpeedKB = totalDownloadedBytes / 1024.0; // 转换为 KB/s
      downloadSpeed = downloadSpeedKB/20;
      // 打印下载速度和总字节数
      print("Download speed: ${downloadSpeedKB.toStringAsFixed(2)} KB/s, Total downloaded bytes: $totalDownloadedBytes");
      // 如果下载速度低于某个阈值，警告
      if (downloadSpeedKB < downloadSpeedThreshold) {
        print("Warning: Video loading slowly");
      }

      // 重置累计字节数和起始时间
      totalDownloadedBytes = 0;
      startTime = currentTime;
      update();
    }
  }

  // 更新已下载字节数
  void updateDownloadedBytesFromDurationRange(DurationRange range) {
    // 计算时间差
    final durationInSeconds = range.end.inSeconds - range.start.inSeconds;
    print("------------: ${durationInSeconds}");
    // 假设每秒下载速度（粗略估算）
    const averageBytesPerSecond = 1024*128; // 512 KB/s

    // 计算总下载字节数
    final downloadedBytes = durationInSeconds * averageBytesPerSecond;

    // 更新累计下载字节数
    totalDownloadedBytes += downloadedBytes;
    update();
    print("Estimated bytes downloaded: $downloadedBytes");
    print("Total downloaded bytes: $totalDownloadedBytes");
  }


}
