import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';
import 'bean/category_with_channels.dart';
import 'bean/channel_with_selection.dart';
import 'logic.dart';
import 'net_speed_logic.dart';

mixin PlayerLogic on GetxController {
  /// 获取 LiveStreamController 的实例
  LiveStreamController get logic => Get.find<LiveStreamController>();
  late BetterPlayerController betterPlayerController;
  int categoryIndex = 0; // 当前分类索引
  int channelIndex = 0; // 当前频道索引
  int? previousCategoryIndex; // 保存上一次的分类索引
  int? previousChannelIndex; // 保存上一次的频道索引
  int settingIndex = 0; //右侧弹窗设置 源和解码
  int decodeIndex = 0; //解码下标
  bool isShowFailPlay=false;
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
        isShowFailPlay=true;
        logic.update();
        break;
      case BetterPlayerEventType.bufferingStart:
        print("-----------第一次");
        logic.startSpeedCalculation(); // 开始计算下载速度

        break;
      case BetterPlayerEventType.bufferingEnd:
        print("-----------第一次结束");
        logic.stopSpeedCalculation(); // 停止计算下载速度


        break;
      case BetterPlayerEventType.bufferingUpdate:
        print("------33-----第一次结束");
        final bufferedList = event.parameters?['buffered'];
        logic.updateDownloadedBytesFromDurationRange(bufferedList[0]);
        break;
      default:
        break;
    }
  }

  // 设置播放器数据源
  void setupPlayer(String? streamUrl) {
    if (streamUrl == null || streamUrl.isEmpty) {
      print("播放地址为空，无法设置数据源");
      return;
    }
    isShowFailPlay=false;
    update();
    betterPlayerController.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamUrl,
      ),
    );
  }


  // 重试逻辑
  void startRetry() {
    print("重试播放...");
    setupPlayer(DataUtils.getCurrentStreamUrl(
        logic.categoryWithChannels, categoryIndex, channelIndex));
    betterPlayerController.play();
  }

  // 停止播放器
  void disposePlayer() {
    betterPlayerController.dispose();
  }

  // 切换频道
  void switchChannel(List<CategoryWithChannels> categories, bool isNext) {
    // 获取当前分类
    var currentCategory = categories[categoryIndex];
    var currentChannels = currentCategory.channels;

    if (currentChannels == null || currentChannels.isEmpty) {
      return; // 当前分类没有频道
    }

    // 更新频道索引
    if (isNext) {
      channelIndex++;
      if (channelIndex >= currentChannels.length) {
        // 切换到下一个分类
        categoryIndex++;
        if (categoryIndex >= categories.length) {
          categoryIndex = 0; // 循环到第一个分类
        }
        currentCategory = categories[categoryIndex];
        currentChannels = currentCategory.channels ?? [];
        channelIndex = 0; // 切换到新分类的第一个频道
      }
    } else {
      channelIndex--;
      if (channelIndex < 0) {
        // 切换到上一个分类
        categoryIndex--;
        if (categoryIndex < 0) {
          categoryIndex = categories.length - 1; // 循环到最后一个分类
        }
        currentCategory = categories[categoryIndex];
        currentChannels = currentCategory.channels ?? [];
        channelIndex = currentChannels.length - 1; // 切换到最后一个频道
      }
    }

    // 更新分类和频道的选中状态
    selectCategory(categories, categoryIndex);
    selectChannel(currentChannels, channelIndex);
    setupPlayer(DataUtils.getCurrentStreamUrl(
        logic.categoryWithChannels, categoryIndex, channelIndex)); //准备数据播放
    // 更新 UI
    update();
  }
  ///设置分类选中
  void selectCategory(
      List<CategoryWithChannels> categories, int categoryIndex) {
    // 将所有分类设置为未选中
    for (var category in categories) {
      category.isSelect = false;
    }

    // 设置目标分类为选中
    categories[categoryIndex].isSelect = true;
  }
  ///设置频道选中
  void selectChannel(List<ChannelWithSelection> channels, int channelIndex) {
    // 将所有频道设置为未选中
    for (var channel in channels) {
      channel.isSelect = false;
    }

    // 设置目标频道为选中
    channels[channelIndex].isSelect = true;
  }

  ///设置频道都是false
  void setChannelFalse(List<ChannelWithSelection> channels){
    for (var channel in channels) {
      channel.isSelect = false;
    }
  }
  ///设置分类和频道都是false
  void resetSelection(List<CategoryWithChannels> categoryWithChannels) {
    for (var category in categoryWithChannels) {
      // 将分类的 isSelect 设置为 false
      category.isSelect = false;

      // 遍历分类中的频道，并将每个频道的 isSelect 设置为 false
      if (category.channels != null) {
        for (var channel in category.channels!) {
          channel.isSelect = false;
        }
      }
    }
  }
}
