import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:refresh_network/home_list/utils/RemoteControlActions.dart';
import 'package:refresh_network/home_list/widget/channel_popup_widget.dart';
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
      body: FocusableActionDetector(
        autofocus: true, // 自动捕获焦点
        shortcuts: RemoteControlActions.shortcuts, // 复用
        actions: controller.getActionsMine(
          context,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            controller.handleVerticalDragEnd(details); // 处理滑动事件
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
                  return controller.isBuffering
                      ? Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                          ),
                        )
                      : Container(); // 不显示黑色背景
                },
              ),
              // 频道切换时显示黑色背景
              GetBuilder<LiveStreamController>(
                builder: (controller) {
                  return controller.isShowFailPlay
                      ? Positioned.fill(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  size: 18.w,
                                  color: Color(0xFFE65100),
                                ), // 使用 Cupertino 图标
                                SizedBox(height: 9.w),
                                Text(
                                  "当前源失效",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8.sp),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(); // 不显示黑色背景
                },
              ),
              //切换频道底部弹框
              ChannelPopupWidget(),
              // 底部弹框显示下一个频道名称
              DownloadSpeedIndicator(),
              //左侧频道分类菜单
              _buildSideMenu(
                context: context,
                position: Position.left,
                onDragEnd: () => controller.showChannelList(context),
                width: width,
              ),

              // 右侧解码器菜单
              _buildSideMenu(
                context: context,
                position: Position.right,
                onDragEnd: () => controller.showDecoderOptions(context),
                width: halfWidth,
              ),
            ],
          ),
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
}
