import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:refresh_network/home_list/update_logic.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../serivice/api_service.dart';
import 'bean/ChannelBean.dart';
import 'net_speed_logic.dart';

class LiveStreamController extends GetxController with NetSpeedLogic,UpdateLogic{
  List categoryChannel=[];//频道分类
  List<ChannelBean> childChannel=[];//子频道集合
  List<ChannelBean>? listChannelBean;//请求多个分类返回的频道集合
  String currentStreamUrl = ""; // 当前播放的流地址
  int currentChannelIndex = 0; // 当前频道的索引
  int currentCategoryIndex = 0; // 当前频分类索引
  List<String> streamUrls=[];
  // 当前选中的频道分类索引，初始化为0表示中央频道
  var selectedIndex = 0;
  late BetterPlayerController betterPlayerController;
  bool isSwitching = false; // 控制是否显示黑色背景和切换动画
  bool showChannelPopup = false; // 用于控制弹框显示


  //直播源
  final List<String> sourceChannels = ["源1", "源2", "源3"];

  final List<String> sourceDecodingChannels = ["系统解码", "LJK硬解", "LJK软解"];


  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  late AndroidDeviceInfo androidInfo;
  Timer? _popupTimer; // 控制弹框延迟的计时器
  final Connectivity _connectivity = Connectivity();
  bool _isRetrying = false; // 防止重复重试
  @override
  Future<void> onInit() async {
    super.onInit();
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
    checkForUpdates();
    getDeviceInfo();
    getChannelData();
    _listenToNetworkChanges(); // 添加网络监听
    setCurrentStreamUrl();
    setupPlayer(currentStreamUrl);
    // 在初始化时配置视频播放器
    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        _startRetry(); // 启动重试逻辑
      }
      // 监听缓冲开始
      if (event.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
        _showLoading(true); // 显示加载提示
      }

      // 监听缓冲更新（可选：在缓冲时更新下载速度）
      else if (event.betterPlayerEventType ==
          BetterPlayerEventType.bufferingUpdate) {
        calculateDownloadSpeed();
      }

      // 监听缓冲结束
      else if (event.betterPlayerEventType ==
          BetterPlayerEventType.bufferingEnd) {
        _showLoading(false); // 隐藏加载提示
        stopSpeedCalculation();
      }
    });
  }
  setCurrentStreamUrl(){
    if (childChannel.isNotEmpty && currentChannelIndex >= 0 && currentChannelIndex < childChannel.length) {
      streamUrls = DataUtils.parseChannelSource(childChannel[currentChannelIndex].channelSource ?? "");
    } else {
      streamUrls = [];
    }
    currentStreamUrl = streamUrls.isNotEmpty ? streamUrls[0] : "";//"https://gcalic.v.myalicdn.com/gc/ztd_1/index.m3u8?contentid=2820180516001";
    print("哈哈哈哈哈哈哈哈哈${currentStreamUrl}");
  }
  void setupPlayer(String? streamUrl) {
    if (streamUrl == null || streamUrl.isEmpty) {
      print("播放地址为空，无法设置数据源");
      return;
    }

    betterPlayerController?.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamUrl,
      ),
    );
  }
  getChannelData()async{
    final prefs = await SharedPreferences.getInstance();
    final qrCodeUrl = prefs.getString('qrCodeUrl'); // 读取字符串
    listChannelBean=await ApiService.appChannelList(qrCodeUrl??"");
    if(listChannelBean==null){
      return;
    }
    categoryChannel=DataUtils.sortChannelCategory(listChannelBean!);
    getChildChannel(listChannelBean!);
    update();
  }
  void getChildChannel(List<ChannelBean> listChannelBean){
    childChannel=listChannelBean.where((item) => item.sort == selectedIndex).toList();
    update();
  }

  void _startRetry() {
    if (_isRetrying) return; // 防止重复调用
    _isRetrying = true;

    print("Starting network retry process...");
    // 不需要额外逻辑，这里等待 _listenToNetworkChanges() 自动处理
  }
  // 显示或隐藏加载提示（底部弹框）
  void _showLoading(bool show) {
    // 更新 UI，控制是否显示加载提示
    isSwitching = show;
    update(); // 通知 GetBuilder 更新 UI
    if (show) {
      showChannelPopup = show;
      update(); // 通知 GetBuilder 更新 UI
    } else {
      // 取消之前的计时器，确保只处理最后一次滑动的延迟
      _popupTimer?.cancel();
      _popupTimer = Timer(const Duration(seconds: 1), () {
        // 延迟 2 秒后隐藏弹框
        showChannelPopup = false;
        update(); // 通知 UI 更新
      });
    }
  }

  void _retryPlay() {
    try {
      print("Retrying playback...");
      betterPlayerController.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          currentStreamUrl, // 重复视频源地址
        ),
      );
      betterPlayerController.play();
    } catch (e) {
      print("Retry play failed: $e");
    }
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
    if (index < 0 || index >= streamUrls.length) return;

    // 设置切换状态为正在切换
    isSwitching = true;

    // 设置新的视频流地址
    currentStreamUrl = streamUrls[index];
    currentChannelIndex = index;

    // 更新视频播放源
    betterPlayerController.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        currentStreamUrl,
      ),
    );

    // 更新UI显示
    update();
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
  void _listenToNetworkChanges() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print("Network status changed: $result");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print("Network is available.");
        _retryPlay();
        // if (_isRetrying) {
        //   _retryPlay();
        //   _isRetrying = false; // 重置状态
        // }
      } else {
        print("Network unavailable.");
      }
    });
  }
}
