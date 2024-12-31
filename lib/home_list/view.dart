import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          // 视频播放器部分
          GetBuilder<LiveStreamController>(
            builder: (_) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  // 根据上下滑动距离判断切换频道
                  if (details.primaryDelta! < 0) {
                    // 向上滑动（下一个频道）
                    _.switchChannel(_.selectedIndex + 1);
                  } else if (details.primaryDelta! > 0) {
                    // 向下滑动（上一个频道）
                    _.switchChannel(_.selectedIndex - 1);
                  }
                },
                child: BetterPlayer(
                  controller: controller.betterPlayerController,
                ),
              );
            },
          ),
          DownloadSpeedIndicator(),  // 下载速度显示框
          // 左侧频道分类菜单
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
        onHorizontalDragEnd: (_) => onDragEnd(),
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
