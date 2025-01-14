import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: FocusableActionDetector(
        autofocus: true, // 自动捕获焦点
        shortcuts: <LogicalKeySet, Intent>{
          // 电视遥控器按键映射
          LogicalKeySet(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): OpenLeftDrawerIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): OpenRightDrawerIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter): ConfirmIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
        },
        actions: <Type, Action<Intent>>{
          // 上下左右键处理
          MoveUpIntent: CallbackAction<MoveUpIntent>(
            onInvoke: (intent) {
              controller.switchChannel(
                controller.categoryWithChannels,
                true,
              );
              return null;
            },
          ),
          MoveDownIntent: CallbackAction<MoveDownIntent>(
            onInvoke: (intent) {
              controller.switchChannel(
                controller.categoryWithChannels,
                false,
              );
              return null;
            },
          ),
          OpenLeftDrawerIntent: CallbackAction<OpenLeftDrawerIntent>(
            onInvoke: (intent) {
              print('打开左侧弹窗');
              showChannelList(context);
              return null;
            },
          ),
          OpenRightDrawerIntent: CallbackAction<OpenRightDrawerIntent>(
            onInvoke: (intent) {
              print('打开右侧弹窗');
              showDecoderOptions(context);
              return null;
            },
          ),
          ConfirmIntent: CallbackAction<ConfirmIntent>(
            onInvoke: (intent) {
              print('确定键被按下');
              return null;
            },
          ),
          BackIntent: CallbackAction<BackIntent>(
            onInvoke: (intent) {
              print('返回键被按下');
              Navigator.pop(context);
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            final velocity = details.velocity.pixelsPerSecond.dy; // 获取滑动速度
            if (velocity < 0) {
              // 向上滑动（下一个频道）
              controller.switchChannel(
                controller.categoryWithChannels,
                true,
              );
            } else if (velocity > 0) {
              // 向下滑动（上一个频道）
              controller.switchChannel(
                controller.categoryWithChannels,
                false,
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
                            margin: const EdgeInsets.only(bottom: 20.0),
                            // 底部间距
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7), // 半透明背景
                              borderRadius: BorderRadius.circular(10.0), // 圆角
                            ),
                            width: double.infinity,
                            // 撑满屏幕宽度
                            height: 80,
                            // 固定高度
                            child: const Row(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.white, size: 20),
                                        SizedBox(height: 4),
                                        Text(
                                          "频道",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16.0), // 间距
                                    // 换台按钮
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.swap_vert,
                                            color: Colors.white, size: 20),
                                        SizedBox(height: 4),
                                        Text(
                                          "换台",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
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
                width: width,
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
    int currentCategoryIndex = 0; // 当前选中的分类索引
    int currentSubCategoryIndex = 0; // 当前选中的子分类索引
    bool isCategoryFocused = true; // 焦点是否在分类列表
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return FocusableActionDetector(
            autofocus: true, // 捕获焦点
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowLeft): MoveLeftIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowRight): MoveRightIntent(),
              LogicalKeySet(LogicalKeyboardKey.enter): ConfirmIntent(),
              LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
            },
            actions: <Type, Action<Intent>>{
              MoveUpIntent: CallbackAction<MoveUpIntent>(
                onInvoke: (intent) {
                  if (isCategoryFocused) {
                    // 焦点在分类列表
                    // currentCategoryIndex =
                    //     (currentCategoryIndex - 1 + controller.categories.length) %
                    //         controller.categories.length;
                  } else {
                    // 焦点在子分类列表
                    // currentSubCategoryIndex = (currentSubCategoryIndex - 1 +
                    //     controller.channels[currentCategoryIndex].length) %
                    //     controller.channels[currentCategoryIndex].length;
                  }
                  controller.update(); // 刷新UI
                  return null;
                },
              ),
              MoveDownIntent: CallbackAction<MoveDownIntent>(
                onInvoke: (intent) {
                  if (isCategoryFocused) {
                    // 焦点在分类列表
                    // currentCategoryIndex =
                    //     (currentCategoryIndex + 1) % controller.categories.length;
                  } else {
                    // 焦点在子分类列表
                    // currentSubCategoryIndex = (currentSubCategoryIndex + 1) %
                    //     controller.channels[currentCategoryIndex].length;
                  }
                  controller.update(); // 刷新UI
                  return null;
                },
              ),
              MoveLeftIntent: CallbackAction<MoveLeftIntent>(
                onInvoke: (intent) {
                  // 切换焦点到分类列表
                  isCategoryFocused = true;
                  controller.update(); // 刷新UI
                  return null;
                },
              ),
              MoveRightIntent: CallbackAction<MoveRightIntent>(
                onInvoke: (intent) {
                  // 切换焦点到子分类列表
                  isCategoryFocused = false;
                  controller.update(); // 刷新UI
                  return null;
                },
              ),
              ConfirmIntent: CallbackAction<ConfirmIntent>(
                onInvoke: (intent) {
                  if (!isCategoryFocused) {
                    // 在子分类列表中按下确定键，选择当前频道
                    // controller.clickRightChannel(index);
                    Navigator.pop(context); // 退出弹窗
                  }
                  return null;
                },
              ),
              BackIntent: CallbackAction<BackIntent>(
                onInvoke: (intent) {
                  Navigator.pop(context); // 关闭弹窗
                  return null;
                },
              ),
            },
            child: ChannelListDialog());
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

// 自定义 Intent 类
class MoveUpIntent extends Intent {}

class MoveDownIntent extends Intent {}

class MoveLeftIntent extends Intent {}

class MoveRightIntent extends Intent {}

class OpenLeftDrawerIntent extends Intent {}

class OpenRightDrawerIntent extends Intent {}

class ConfirmIntent extends Intent {}

class BackIntent extends Intent {}
