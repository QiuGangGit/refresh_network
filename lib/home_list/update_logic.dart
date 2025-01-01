import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

mixin UpdateLogic on GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkForUpdates() async {
    // 模拟接口返回的数据
    final updateInfo = {
      "latestVersion": "2.0.0",
      "isForceUpdate": true,
      "updateUrl": "https://example.com/app.apk",
      "updateMessage": "New version available! Fixes and improvements."
    };

    final currentVersion = "1.0.0"; // 当前版本号
    if (_shouldUpdate(currentVersion, updateInfo["latestVersion"].toString())) {
      _showUpdateDialog(
        Get.context!,
        updateInfo["isForceUpdate"] as bool,
        updateInfo["updateMessage"] as String,
        updateInfo["updateUrl"] as String,
      );
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    // 简单版本号比较，更多逻辑可以自行扩展
    return currentVersion != latestVersion;
  }

  void _showUpdateDialog(BuildContext context, bool isForceUpdate,
      String message, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: !isForceUpdate, // 如果是强制更新，禁止点击外部关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Available"),
          content: Text(message),
          actions: [
            if (!isForceUpdate)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 非强制更新时允许关闭弹窗
                },
                child: const Text("Cancel"),
              ),
            TextButton(
              onPressed: () {
                startUpdate(updateUrl); // 跳转到更新链接
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  double downloadProgress = 0.0; // 下载进度
  String apkFilePath = ''; // 下载后的 APK 文件路径

  void startUpdate(String url) async {
    try {
      // 获取临时目录
      Directory tempDir = await getTemporaryDirectory();
      String savePath = "${tempDir.path}/update.apk";

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
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Page")),
      body: Center(
        child: downloadProgress > 0 && downloadProgress < 1
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Downloading... ${(downloadProgress * 100).toStringAsFixed(1)}%"),
                  SizedBox(height: 20),
                  LinearProgressIndicator(value: downloadProgress),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  startUpdate("https://example.com/app.apk"); // 替换为实际 APK 链接
                },
                child: Text("Start Update"),
              ),
      ),
    );
  }
}
