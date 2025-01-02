import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:refresh_network/home_list/widget/channel_list_widget.dart';
import 'package:refresh_network/home_list/widget/decoder_options_widget.dart';
import 'logic.dart';
import 'widget/download_speed_widget.dart'; // 导入控制器

enum Position { left, right }

class LiveStreamingPage extends StatelessWidget {
  LiveStreamingPage({Key? key}) : super(key: key);
  final LiveStreamController controller = Get.put(LiveStreamController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double halfWidth = width / 2;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dy; // 获取滑动速度
          if (velocity < 0) {
            // 向上滑动（下一个频道）
            controller.switchChannel(
              controller.currentChannelIndex >=
                      controller.channelData.length - 1
                  ? 0
                  : controller.currentChannelIndex + 1,
            );
          } else if (velocity > 0) {
            // 向下滑动（上一个频道）
            controller.switchChannel(
              controller.currentChannelIndex <= 0
                  ? controller.channelData.length - 1
                  : controller.currentChannelIndex - 1,
            );
          }
        },
        child: Stack(
          children: [
            // 视频播放器部分
            GetBuilder<LiveStreamController>(
              builder: (_) {
                return BetterPlayer(
                  controller: controller.betterPlayerController,
                );
              },
            ),
            // 频道切换时显示黑色背景
            GetBuilder<LiveStreamController>(
              builder: (controller) {
                return controller.isSwitching
                    ? Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      )
                    : Container(); // 不显示黑色背景
              },
            ),
            // 底部弹框显示下一个频道名称
            GetBuilder<LiveStreamController>(
              builder: (controller) {
                return Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width * 0.5 -
                      (100.w / 2), // 居中计算
                  // right: 20,
                  child: controller.showChannelPopup
                      ? Container(
                      margin: const EdgeInsets.only(bottom: 20.0), // 底部间距
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7), // 半透明背景
                        borderRadius: BorderRadius.circular(10.0), // 圆角
                      ),
                      width: double.infinity, // 撑满屏幕宽度
                      height: 80, // 固定高度
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 左侧频道号
                          Text(
                            "54",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16.0), // 间距
                          // 中间频道名称
                          Expanded(
                            child: Text(
                              "佳木斯综合",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis, // 超出部分省略号
                            ),
                          ),
                          // 右侧功能按钮
                          Row(
                            children: [
                              // 频道按钮
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  SizedBox(height: 4),
                                  Text(
                                    "频道",
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16.0), // 间距
                              // 换台按钮
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.swap_vert, color: Colors.white, size: 20),
                                  SizedBox(height: 4),
                                  Text(
                                    "换台",
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ))
                      : Container(), // 不显示底部弹框
                );
              },
            ),
            DownloadSpeedIndicator(), // 下载速度显示框
            //左侧频道分类菜单
            _buildSideMenu(
              context: context,
              position: Position.left,
              onDragEnd: () => showChannelList(context),
              width: halfWidth,
            ),

            // 右侧解码器菜单
            _buildSideMenu(
              context: context,
              position: Position.right,
              onDragEnd: () => showDecoderOptions(context),
              width: halfWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideMenu({
    required BuildContext context,
    required Position position,
    required VoidCallback onDragEnd,
    required double width,
  }) {
    return Positioned(
      left: position == Position.left ? 0 : width,
      right: position == Position.right ? 0 : null,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // 确保手势透传
        onTap: () => onDragEnd(),
        child: Container(
          width: width,
          height: double.infinity,
          color: Colors.transparent,
        ),
      ),
    );
  }

  // 显示频道列表
  void showChannelList(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const ChannelListDialog();
      },
    );
  }

  void showDecoderOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const DecoderOptionsDialog();
      },
    );
  }
}
