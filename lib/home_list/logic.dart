import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:refresh_network/home_list/player_logic.dart';
import 'package:refresh_network/home_list/sliding_event_logic.dart';
import 'package:refresh_network/home_list/update_logic.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../serivice/api_service.dart';
import 'bean/ChannelBean.dart';
import 'bean/category_with_channels.dart';
import 'net_speed_logic.dart';

class LiveStreamController extends GetxController
    with NetSpeedLogic, UpdateLogic, PlayerLogic, SlidingEventLogic {
  late List<CategoryWithChannels> categoryWithChannels= [];

  // 界面状态
  bool showChannelPopup = false; // 弹框显示状态
  Timer? _popupTimer; // 计时器
  // 网络和设备信息
  final Connectivity _connectivity = Connectivity();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;

  // 解码选项
  final List<String> sourceDecodingChannels = ["系统解码", "LJK硬解", "LJK软解"];

  @override
  Future<void> onInit() async {
    super.onInit();
    getAppVersion();
    initializePlayer();
    getDeviceInfo(); //TODO 设备和网络放到一个logic
    checkForUpdates();
    getChannelData(); //获取频道数据
    sendOnline();//设备上线
    _listenToNetworkChanges(); // 网络监听断网重连
  }

  // 显示弹框并重置计时器
  void showPopup() {
    showChannelPopup = true;
    update(); // 通知 UI 更新

    // 如果已有计时器，先取消
    _popupTimer?.cancel();

    // 创建新的计时器，2 秒后隐藏弹框
    _popupTimer = Timer(const Duration(seconds: 2), () {
      showChannelPopup = false;
      update(); // 通知 UI 更新
    });
  }

  ///获取频道数据
  getChannelData() async {
    final prefs = await SharedPreferences.getInstance();
    final qrCodeUrl = prefs.getString('qrCodeUrl'); // 读取字符串
    List<ChannelBean>? listChannelBean =
        await ApiService.appChannelList(qrCodeUrl ?? "");
    if (listChannelBean == null) {
      return;
    }
    // 转换为分类和频道结构
    categoryWithChannels = DataUtils.organizeChannelData(listChannelBean!);
    selectCategory(categoryWithChannels, categoryIndex);
    selectChannel(
        categoryWithChannels[categoryIndex].channels ?? [], channelIndex);
    // 输出分类及其频道
    for (var category in categoryWithChannels) {
      print("分类: ${category.categoryName} (sort: ${category.sort})");
      for (var channel in category.channels ?? []) {
        print(
            "  - 频道: ${channel.channelName}, 选中状态: ${channel.isSelect}, 频道源: ${channel.channelSource}");
      }
    }
    setupPlayer(DataUtils.getCurrentStreamUrl(
        categoryWithChannels, categoryIndex, channelIndex)); //准备数据播放
    update();
  }

  @override
  void onClose() {
    super.onClose();
    betterPlayerController.dispose();
    _popupTimer?.cancel(); // 关闭页面时清理计时器
  }

  /// 左侧分类菜单部分 频道分类点击
  void clickLeftMenuCategory(int index,{savesaveCurrent=true}) {
    if (categoryIndex == index) {
      return;
    }
    // 保存之前的选中状态
    if(savesaveCurrent&&previousCategoryIndex==null&&previousChannelIndex==null){
      previousCategoryIndex = categoryIndex;
      previousChannelIndex = categoryWithChannels[categoryIndex]
          .channels
          ?.indexWhere((channel) => channel.isSelect == true);
    }


    // 更新为新分类
    categoryIndex = index;
    selectCategory(categoryWithChannels, categoryIndex);

    // 清空新分类的频道选中状态
    setChannelFalse(categoryWithChannels[categoryIndex].channels ?? []);

    // selectChannel(
    //     categoryWithChannels[categoryIndex].channels ?? [], channelIndex);

    update();
  }

  ///点击左侧分类+没有在左侧弹框选择频道+返回的情况
  void restorePreviousSelection() {
    if (previousCategoryIndex != null && previousChannelIndex != null) {
      // 恢复分类和频道的选中状态
      categoryIndex = previousCategoryIndex!;
      channelIndex=previousChannelIndex!;
      selectCategory(categoryWithChannels, categoryIndex);

      if (previousChannelIndex! >= 0 &&
          previousChannelIndex! <
              categoryWithChannels[categoryIndex].channels!.length) {
        categoryWithChannels[categoryIndex]
            .channels![channelIndex!]
            .isSelect = true;
      }


      // 清空之前保存的状态
      previousCategoryIndex = null;
      previousChannelIndex = null;

      update();
    }
  }

  ///右侧频道部分 切换选台
  void clickRightChannel(int index) {
    // 清空之前保存的状态
    previousCategoryIndex = null;
    previousChannelIndex = null;
    channelIndex = index; // 当前频道索引
    // 更新选中状态
    selectCategory(categoryWithChannels, categoryIndex);
    selectChannel(
        categoryWithChannels[categoryIndex].channels ?? [], channelIndex);

    setupPlayer(DataUtils.getCurrentStreamUrl(
        categoryWithChannels, categoryIndex, channelIndex)); //准备数据播放
    update();
    Get.back(); // 关闭频道列表
  }

  ///监听网络变化
  void _listenToNetworkChanges() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print("Network status changed: $result");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print("Network is available.");
        startRetry();
      } else {
        print("Network unavailable.");
      }
    });
  }

  ///获取设备信息
  Future<void> getDeviceInfo() async {
    try {
      // 获取设备信息
      if (Platform.isAndroid) {
        androidInfo = await _deviceInfoPlugin.androidInfo;
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }
}
