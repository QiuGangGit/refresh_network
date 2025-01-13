import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';

import 'bean/ChannelBean.dart';
import 'net_speed_logic.dart';

mixin PlayerLogic on GetxController {
  late BetterPlayerController betterPlayerController;
  String currentStreamUrl = ""; // 当前播放流地址
  List<String> streamUrls = []; // 当前频道所有播放源
  int currentStreamIndex = 0; // 当前播放源的索引
  bool isSwitching = false; // 是否切换状态
  int currentChannelIndex = 0; // 当前频道索引
  // 初始化播放器
  void initializePlayer() {
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
          DeviceOrientation.landscapeRight,
        ],
      ),
    );

    betterPlayerController.addEventsListener((event) {
      handlePlayerEvent(event);
    });
  }

  // 处理播放器事件
  void handlePlayerEvent(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.exception:
        startRetry();
        break;
      case BetterPlayerEventType.bufferingStart:
        showLoading(true);
        break;
      case BetterPlayerEventType.bufferingEnd:
        showLoading(false);
        break;
      case BetterPlayerEventType.bufferingUpdate:
        (this as NetSpeedLogic).calculateDownloadSpeed();
        break;
      default:
        break;
    }
  }

  // 设置当前播放地址
  void setCurrentStreamUrl(List<ChannelBean> childChannel, int currentChannelIndex) {
    if (childChannel.isNotEmpty &&
        currentChannelIndex >= 0 &&
        currentChannelIndex < childChannel.length) {
      streamUrls =
          DataUtils.parseChannelSource(childChannel[currentChannelIndex].channelSource ?? "");
    } else {
      streamUrls = [];
    }
    currentStreamUrl = streamUrls.isNotEmpty ? streamUrls[0] : "";
  }

  // 设置播放器数据源
  void setupPlayer(String? streamUrl) {
    if (streamUrl == null || streamUrl.isEmpty) {
      print("播放地址为空，无法设置数据源");
      return;
    }

    betterPlayerController.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamUrl,
      ),
    );
  }

  // 切换播放源
  void switchStream(int index) {
    if (index < 0 || index >= streamUrls.length) return;

    isSwitching = true;
    currentStreamUrl = streamUrls[index];
    currentStreamIndex = index;

    setupPlayer(currentStreamUrl);
    update();
  }

  // 模拟加载过程
  void showLoading(bool show) {
    isSwitching = show;
    update();
  }

  // 重试逻辑
  void startRetry() {
    print("重试播放...");
    setupPlayer(currentStreamUrl);
    betterPlayerController.play();
  }

  // 停止播放器
  void disposePlayer() {
    betterPlayerController.dispose();
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
}