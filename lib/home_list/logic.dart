import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'net_speed_logic.dart';

class LiveStreamController extends GetxController with NetSpeedLogic {
  List<dynamic> channelData = []; // 频道数据
  String currentStreamUrl = ""; // 当前播放的流地址
  int currentChannelIndex = 0; // 当前频道的索引
  late BetterPlayerController betterPlayerController;

  // 模拟中央频道数据列表
  final List<String> centralChannels = [
    "CCTV1",
    "CCTV2",
    "CCTV3",
    "CCTV1",
    "CCTV2",
    "CCTV3",
    "CCTV1",
    "CCTV2",
    "CCTV3",
    "CCTV1",
    "CCTV2",
    "CCTV3"
  ];

  // 模拟卫视频道数据列表
  final List<String> satelliteChannels = ["湖南卫视", "浙江卫视", "江苏卫视"];

  // 模拟本地频道数据列表
  final List<String> localChannels = ["本地综合频道", "本地生活频道", "本地影视频道"];

  //直播源
  final List<String> sourceChannels = ["源1", "源2", "源3"];

  final List<String> sourceDecodingChannels = ["系统解码", "LJK硬解", "LJK软解"];

  // 当前选中的频道分类索引，初始化为0表示中央频道
  var selectedIndex = 0;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  late AndroidDeviceInfo androidInfo;

  @override
  Future<void> onInit() async {
    super.onInit();
    getDeviceInfo();
    channelData = [
      "https://test-hls-streams.s3.amazonaws.com/playlist.m3u8",
      "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
    ];
    currentStreamUrl = "https://dl2.apexteam.net/pana/vendor/course_1.mp4";
    //"https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8";
    betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false, // 隐藏控制按钮
        ),
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          // 设置全屏后的设备方向为横屏向左（可根据需求选landscapeRight等）
          DeviceOrientation.landscapeRight,
        ],
      ),
    );
    final streamUrl = await getStreamUrl("https://live.kilvn.com/radio.m3u");
    betterPlayerController.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        // streamUrl,
        "https://gcalic.v.myalicdn.com/gc/ztd_1/index.m3u8?contentid=2820180516001",
      ),
    );
    // 在初始化时配置视频播放器
    betterPlayerController.addEventsListener((event) {
      // 监听缓冲开始
      if (event.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
      }

      // 监听缓冲更新（可选：在缓冲时更新下载速度）
      else if (event.betterPlayerEventType ==
          BetterPlayerEventType.bufferingUpdate) {
        calculateDownloadSpeed();
      }

      // 监听缓冲结束
      else if (event.betterPlayerEventType ==
          BetterPlayerEventType.bufferingEnd) {
        stopSpeedCalculation();
      }
    });
  }

// 监听缓存进度
  void checkBufferedProgress() {
    betterPlayerController.videoPlayerController!.addListener(() {
      final buffered =
          betterPlayerController.videoPlayerController!.value.buffered;
      if (buffered.isNotEmpty) {
        // 获取缓存的总进度（以秒为单位）
        final bufferedDuration = buffered.last.end.inSeconds;
        print("Buffered up to: $bufferedDuration seconds");

        // 根据缓存进度判断视频是否加载缓慢
        if (bufferedDuration < 10) {
          print(
              "Warning: Video loading slowly (less than 10 seconds buffered).");
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    betterPlayerController.dispose();
  }

  // 获取频道列表（实际后台接口请求）
  // Future<void> fetchChannels() async {
  //   try {
  //     // 替换为实际的 API 地址
  //     final response =
  //         await http.get(Uri.parse('https://your-backend-api.com/channels'));
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       channelData = data; // 更新频道数据
  //       currentStreamUrl = data[0]['streamUrl']; // 默认播放第一个频道
  //       update(); // 通知 GetBuilder 更新 UI
  //     }
  //   } catch (e) {
  //     print("Error fetching channel data: $e");
  //   }
  // }
  Future<String> getStreamUrl(String m3uUrl) async {
    final response = await http.get(Uri.parse(m3uUrl));
    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      for (var line in lines) {
        // 忽略注释行，返回第一个有效的 URL
        if (!line.startsWith('#') && line.isNotEmpty) {
          print("---------${line.trim()}");
          return line.trim();
        }
      }
    }
    throw Exception("Unable to fetch stream URL from m3u file.");
  }

  // 切换频道
  void switchChannel(int index) {
    currentChannelIndex = index;
    currentStreamUrl = channelData[index]['streamUrl'];
    update(); // 通知 GetBuilder 更新 UI
  }

  //寻找下标
  List<String>? getCurrentChannels() {
    if (selectedIndex == 0) {
      return centralChannels;
    } else if (selectedIndex == 1) {
      return satelliteChannels;
    } else if (selectedIndex == 2) {
      return localChannels;
    }
    return null;
  }

  Future<void> getDeviceInfo() async {
    try {
      // 获取设备信息
      if (Platform.isAndroid) {
        androidInfo = await _deviceInfoPlugin.androidInfo;
        print('Android Model: ${androidInfo.model}'); // 获取设备型号
        print(
            'Android Version: ${androidInfo.version.release}'); // 获取 Android 系统版本
        print('Android Device: ${androidInfo.device}'); // 获取设备 ID
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }
}
