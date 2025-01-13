import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:refresh_network/home_list/player_logic.dart';
import 'package:refresh_network/home_list/update_logic.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../serivice/api_service.dart';
import 'bean/ChannelBean.dart';
import 'net_speed_logic.dart';

class LiveStreamController extends GetxController
    with NetSpeedLogic, UpdateLogic, PlayerLogic {
  // 频道相关
  List categoryChannel = []; // 频道分类
  List<ChannelBean> childChannel = []; // 当前分类的子频道集合
  List<ChannelBean>? listChannelBean; // 请求返回的所有频道集合
  int currentCategoryIndex = 0; // 当前分类索引
  var selectedCategoryIndex = 0; // 选中的频道分类索引
  var selectedIndex = 0;

  // 界面状态
  bool isSwitching = false; // 是否显示切换动画
  bool showChannelPopup = false; // 弹框显示状态

  // 网络和设备信息
  final Connectivity _connectivity = Connectivity();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;

  // 解码选项
  final List<String> sourceDecodingChannels = ["系统解码", "LJK硬解", "LJK软解"];
  int currentDecodingIndex = 0; // 当前解码方式

  @override
  Future<void> onInit() async {
    super.onInit();
    initializePlayer();
    getDeviceInfo(); //TODO 设备和网络放到一个logic
    checkForUpdates();
    getChannelData(); //获取频道数据
    _listenToNetworkChanges(); // 添加网络监听
    setupPlayer(currentStreamUrl); //准备数据播放
  }

  ///获取频道数据
  getChannelData() async {
    final prefs = await SharedPreferences.getInstance();
    final qrCodeUrl = prefs.getString('qrCodeUrl'); // 读取字符串
    listChannelBean = await ApiService.appChannelList(qrCodeUrl ?? "");
    if (listChannelBean == null) {
      return;
    }
    categoryChannel = DataUtils.sortChannelCategory(listChannelBean!);
    childChannel = DataUtils.getChildChannel(listChannelBean!, selectedIndex);
    setCurrentStreamUrl(childChannel, currentChannelIndex);
    update();
  }

  @override
  void onClose() {
    super.onClose();
    betterPlayerController.dispose();
  }

  /// 左侧分类菜单部分 频道分类点击
  void clickLeftMenuCategory(int index) {
    selectedIndex = index;
    childChannel = DataUtils.getChildChannel(listChannelBean!, selectedIndex);
    update();
  }

  ///右侧频道部分 切换选台
  void clickRightChannel(int index) {
    currentChannelIndex = index;
    currentCategoryIndex == selectedIndex;
    setCurrentStreamUrl(childChannel, currentChannelIndex);
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
        // if (_isRetrying) {
        //   _retryPlay();
        //   _isRetrying = false; // 重置状态
        // }
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
