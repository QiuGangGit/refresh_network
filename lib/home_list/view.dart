import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic.dart'; // 导入控制器

void main() {
  runApp(LiveStreamingApp());
}

class LiveStreamingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveStreamingPage(),
    );
  }
}

class LiveStreamingPage extends StatelessWidget {
  final LiveStreamController controller =
      Get.put(LiveStreamController()); // 初始化控制器

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 视频播放器部分
          GetBuilder<LiveStreamController>(
            builder: (_) {
              return BetterPlayer(
                controller: controller.betterPlayerController,
              );
            },
          ),

          // 左侧频道分类菜单
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onHorizontalDragEnd: (_) => showChannelList(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),

          // 右侧解码器菜单
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            top: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragEnd: (_) => showDecoderOptions(
                context,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 显示频道列表
  void showChannelList(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 透明的遮罩层，用于拦截屏幕触摸事件，防止点击穿透
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Container(color: Colors.transparent),
              ),
            ),
            // 实际的对话框内容
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow,
                  child: Row(
                    children: [
                      // 左侧分类
                      Container(
                        width: 100,
                        color: Colors.grey[200],
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: Text("中央频道"),
                              onTap: () {
                                // 更新选中的频道分类索引为中央频道（索引为0）
                                Get.find<LiveStreamController>().selectedIndex =
                                    0;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                            ),
                            ListTile(
                              title: Text("卫视频道"),
                              onTap: () {
                                // 更新选中的频道分类索引为卫视频道（索引为1）
                                Get.find<LiveStreamController>().selectedIndex =
                                    1;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                            ),
                            ListTile(
                              title: Text("本地频道"),
                              onTap: () {
                                // 更新选中的频道分类索引为本地频道（索引为2）
                                Get.find<LiveStreamController>().selectedIndex =
                                    2;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                            ),
                          ],
                        ),
                      ),
                      // 右侧频道列表
                      Expanded(
                        child: GetBuilder<LiveStreamController>(
                          builder: (_) {
                            // 根据当前选中的频道分类索引，显示相应的频道列表
                            List<String> currentChannels = [];
                            if (Get.find<LiveStreamController>()
                                    .selectedIndex ==
                                0) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .centralChannels;
                            } else if (Get.find<LiveStreamController>()
                                    .selectedIndex ==
                                1) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .satelliteChannels;
                            } else if (Get.find<LiveStreamController>()
                                    .selectedIndex ==
                                2) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .localChannels;
                            }
                            return ListView.builder(
                              itemCount: currentChannels.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(currentChannels[index]),
                                  onTap: () {
                                    // 在这里处理频道切换逻辑，例如：
                                    // controller.switchChannel(index);
                                    Get.back(); // 关闭频道列表
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDecoderOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 透明的遮罩层，用于拦截屏幕触摸事件，防止点击穿透
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Container(color: Colors.transparent),
              ),
            ),
            // 实际的对话框内容
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow,
                  child: Row(
                    children: [
                      Expanded(
                        child: GetBuilder<LiveStreamController>(
                          builder: (_) {
                            // 根据当前选中的分类索引，显示相应的频道列表
                            List<String> currentChannels = [];
                            if (Get.find<LiveStreamController>()
                                .selectedIndex ==
                                0) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .sourceChannels;
                            } else if (Get.find<LiveStreamController>()
                                .selectedIndex ==
                                1) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .sourceDecodingChannels;
                            }
                            return ListView.builder(
                              itemCount: currentChannels.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(currentChannels[index]),
                                  onTap: () {
                                    // 在这里处理选择直播源或视频解码选项后的逻辑
                                    Get.back(); // 关闭对话框
                                    // 可以根据需要添加更多具体操作，例如设置解码器等
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 100,
                        color: Colors.grey[200],
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: Text("直播源"),
                              onTap: () {
                                // 更新选中的分类索引为直播源（索引为0）
                                Get.find<LiveStreamController>().selectedIndex =
                                    0;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                            ),
                            ListTile(
                              title: Text("视频解码"),
                              onTap: () {
                                // 更新选中的分类索引为视频解码（索引为1）
                                Get.find<LiveStreamController>().selectedIndex =
                                    1;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
