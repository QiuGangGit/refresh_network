import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refresh_network/request/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../request/base_response.dart';
import '../serivice/api_service.dart';
import 'bean/UpdateBean.dart';
import 'logic.dart';

mixin UpdateLogic on GetxController {
  String appVersion="";
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkForUpdates() async {
    String currentVersion = await getAppVersion(); // 当前版本号
    AppUpdateBean? appUpdateBean =
        await ApiService.appVersionCheck(currentVersion);

    if (appUpdateBean!=null&&_shouldUpdate(
        currentVersion, appUpdateBean.appversion ?? currentVersion)) {
      _showUpdateDialog(
        Get.context!,
        appUpdateBean.isForceUpdate ?? false,
        appUpdateBean.appContent ?? "",
        appUpdateBean.appDownloadUrl ?? "",
      );
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    List<int> remoteParts = latestVersion.split('.').take(3).map(int.parse).toList();
    List<int> currentParts = currentVersion.split('.').take(3).map(int.parse).toList();

    // 转换为整数进行比较
    int remoteValue = int.parse(remoteParts.join());
    int currentValue = int.parse(currentParts.join());

    print('Remote Value: $remoteValue');
    print('Current Value: $currentValue');

    // 返回比较结果
    return remoteValue > currentValue;
  }

  void _showUpdateDialog(BuildContext context, bool isForceUpdate,
      String message, String updateUrl) {
    Get.dialog(
      GetBuilder<LiveStreamController>(builder: (logic) {
        return AlertDialog(
          title: const Text("有更新可用"),
          content: isDownloading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("下载中，请稍候..."),
                    SizedBox(height: 16.w),
                    LinearProgressIndicator(
                      value: logic.downloadProgress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                        "${(logic.downloadProgress * 100).toStringAsFixed(1)}%"),
                  ],
                )
              : Text(message),
          actions: [
            if (!isForceUpdate && !isDownloading)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 非强制更新时允许关闭弹窗
                },
                child: const Text("取消"),
              ),
            if (!isDownloading)
              TextButton(
                onPressed: () async {
                  isDownloading = true;
                  update();
                  startUpdate(updateUrl);
                },
                child: const Text("更新"),
              ),
          ],
        );
      }),
      barrierDismissible: !isForceUpdate, // 如果是强制更新，禁止点击外部关闭
    );
  }

  double downloadProgress = 0.0; // 下载进度
  String apkFilePath = ''; // 下载后的 APK 文件路径
  bool isDownloading = false; // 是否正在下载
  void startUpdate(String url) async {
    try {
      // 获取临时目录
      Directory tempDir = await getTemporaryDirectory();
      String savePath = "${tempDir.path}/update.apk";
      print("----------$url");
      // 开始下载
      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          downloadProgress = received / total; // 计算下载进度

          update();
        },
      );

      // 下载完成后，设置文件路径
      apkFilePath = savePath;
      update();
      // 安装 APK
      installApk();
      isDownloading = false;
    } catch (e) {
      isDownloading = false;
      print("Error during update: $e");
    }
  }

  void installApk() {
    if (apkFilePath.isNotEmpty) {
      InstallPlugin.installApk(apkFilePath)
          .then((_) => print("Install complete"))
          .catchError((e) => print("Install failed: $e"));
    }
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion=packageInfo.version;
    update();
    return packageInfo.version; // 获取当前应用的版本
  }

  void sendOnline() async {
    final prefs = await SharedPreferences.getInstance();
    String? qrCodeUrl = prefs.getString('qrCodeUrl') ?? "";
    BaseResponse? baseResponse =
        await ApiService.appHotelDeviceOnline(qrCodeUrl, "1");
    if (baseResponse?.code == 0) {
      print("------------设备上线了");
    } else {
      print("------------${baseResponse?.msg}");
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
