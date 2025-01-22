import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:refresh_network/home_list/utils/DataUtils.dart';
import 'package:refresh_network/home_list/utils/RemoteControlActions.dart';
import 'package:refresh_network/home_list/widget/channel_list_widget.dart';
import 'package:refresh_network/home_list/widget/decoder_options_widget.dart';
import 'package:refresh_network/home_list/widget/device_info_widget.dart';

import 'bean/channel_with_selection.dart';
import 'logic.dart';

mixin SlidingEventLogic on GetxController {
  LiveStreamController get logic => Get.find<LiveStreamController>();

  //手机屏幕上下滑动事件
  void handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy; // 获取滑动速度

    if (velocity < 0) {
      // 向上滑动（下一个频道）
      logic.switchChannel(logic.categoryWithChannels, true);
      logic.isShowFailPlay = false;
      logic.showPopup(); // 每次滑动都触发弹框
    } else if (velocity > 0) {
      // 向下滑动（上一个频道）
      logic.switchChannel(logic.categoryWithChannels, false);
      logic.isShowFailPlay = false;
      logic.showPopup(); // 每次滑动都触发弹框
    }
  }

  // 主页面的遥控器 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsMine(BuildContext context) {
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          //切换台UP==下滑
          logic.switchChannel(
            logic.categoryWithChannels,
            false,
          );
          logic.isShowFailPlay = false;
          logic.showPopup(); // 每次滑动都触发弹框
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          // 向上滑动（下一个频道）
          logic.switchChannel(
            logic.categoryWithChannels,
            true,
          );
          logic.isShowFailPlay = false;
          logic.showPopup(); // 每次滑动都触发弹框
        },
      ),
      MoveLeftIntent: CallbackAction<MoveLeftIntent>(
        onInvoke: (intent) {
          print("----111------");
          // 切换焦点到子分类列表
          logic.showDecoderOptions(context);
          update(); // 刷新UI
          return null;
        },
      ),
      MoveRightIntent: CallbackAction<MoveRightIntent>(
        onInvoke: (intent) {
          print("----22222------");
          // 切换焦点到分类列表
          logic.showChannelList(context);
          update(); // 刷新UI
          return null;
        },
      ),
      BackIntent: CallbackAction<BackIntent>(
        onInvoke: (intent) {
          print("----22222------");
          logic.sendOffline();
          Navigator.pop(context); // 关闭弹窗
          return null;
        },
      ),
      HomeIntent: CallbackAction<HomeIntent>( // Home 键触发的事件
        onInvoke: (intent) {
          print("Home button pressed");
          logic.sendOffline(); // 发送离线请求
          Get.back();
          return null;
        },
      ),
    };
  }

  // 左侧弹窗选择频道的遥控器事件 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsLeftMenu(BuildContext context) {
    bool isCategoryFocused = false; // 焦点是否在分类列表
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          if (isCategoryFocused) {
            logic.clickLeftMenuCategory(
                logic.categoryIndex == 0
                    ? logic.categoryWithChannels.length - 1
                    : logic.categoryIndex - 1,
                savesaveCurrent: false);
          } else {
            saveCurrentSelection();
            switchToPreviousChannel();
          }
          update(); // 刷新UI
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          if (isCategoryFocused) {
            logic.clickLeftMenuCategory(
                logic.categoryIndex == logic.categoryWithChannels.length - 1
                    ? 0
                    : logic.categoryIndex + 1,
                savesaveCurrent: false);
          } else {
            saveCurrentSelection();
            switchToNextChannel(); // 下滑切换到下一个频道
          }
          update(); // 刷新UI
          return null;
        },
      ),
      MoveLeftIntent: CallbackAction<MoveLeftIntent>(
        onInvoke: (intent) {
          // 切换焦点到分类列表
          if (isCategoryFocused == false) {
            isCategoryFocused = true;
            saveCurrentSelection();
            logic.setChannelFalse(
                logic.categoryWithChannels[logic.categoryIndex].channels ?? []);
            update(); // 刷新UI
          }

          return null;
        },
      ),
      MoveRightIntent: CallbackAction<MoveRightIntent>(
        onInvoke: (intent) {
          // 切换焦点到子分类列表
          if (isCategoryFocused) {
            isCategoryFocused = false;
            // 保存之前的选中状态

            logic.categoryWithChannels[logic.categoryIndex].channels?[0]
                .isSelect = true;
            update(); // 刷新UI
          }

          return null;
        },
      ),
      ConfirmIntent: CallbackAction<ConfirmIntent>(
        onInvoke: (intent) {
          if (!isCategoryFocused) {
            deleteCurrentSelection();
            // 在子分类列表中按下确定键，选择当前频道
            logic.setupPlayer(DataUtils.getCurrentStreamUrl(
                logic.categoryWithChannels,
                logic.categoryIndex,
                logic.channelIndex)); //准备数据播放
            Navigator.pop(context); // 退出弹窗
          }
          return null;
        },
      ),
      BackIntent: CallbackAction<BackIntent>(
        onInvoke: (intent) {
          logic.resetSelection(logic.categoryWithChannels);
          logic.restorePreviousSelection();
          Navigator.pop(context); // 关闭弹窗
          return null;
        },
      ),
    };
  }

  // 右侧弹窗选择频道的遥控器事件 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsRightMenu(BuildContext context) {
    bool isCategoryFocused = true; // 焦点是否在分类列表
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          if (isCategoryFocused) {
            // 向上切换
            logic.settingIndex = (logic.settingIndex - 1 + 3) % 3; // 2 -> 1 -> 0 -> 2
            logic.update();
          } else {
            // 更新 currentSourceIndex 或 decodeIndex，保证循环切换
            if (logic.settingIndex == 0) {
              var channel = logic.categoryWithChannels[logic.categoryIndex]
                  .channels![logic.channelIndex];
              channel.currentSourceIndex = (channel.currentSourceIndex -
                      1 +
                      channel.channelSource!.length) %
                  channel.channelSource!.length;
            } else {
              logic.decodeIndex = (logic.decodeIndex -
                      1 +
                      logic.sourceDecodingChannels.length) %
                  logic.sourceDecodingChannels.length;
            }
            Get.back(); // 关闭对话框
          }
          update(); // 刷新UI
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          if (isCategoryFocused) {
            logic.settingIndex = (logic.settingIndex + 1) % 3; // 循环切换 0 -> 1 -> 2 -> 0
            logic.update();
          } else {
            // 更新 currentSourceIndex 或 decodeIndex，确保下标加1并且循环
            if (logic.settingIndex == 0) {
              var channel = logic.categoryWithChannels[logic.categoryIndex]
                  .channels![logic.channelIndex];
              // 下标加1，并确保循环
              channel.currentSourceIndex = (channel.currentSourceIndex + 1) %
                  channel.channelSource!.length;
            } else {
              // 下标加1，并确保循环
              logic.decodeIndex =
                  (logic.decodeIndex + 1) % logic.sourceDecodingChannels.length;
            }
            Get.back(); // 关闭对话框
          }
          update(); // 刷新UI
          return null;
        },
      ),
      MoveLeftIntent: CallbackAction<MoveLeftIntent>(
        onInvoke: (intent) {
          isCategoryFocused = false;
          update(); // 刷新UI
          return null;
        },
      ),
      MoveRightIntent: CallbackAction<MoveRightIntent>(
        onInvoke: (intent) {
          isCategoryFocused = true;
          update(); // 刷新UI
          return null;
        },
      ),
      ConfirmIntent: CallbackAction<ConfirmIntent>(
        onInvoke: (intent) {
          print('确定键被按下');
          if (!isCategoryFocused) {
            logic.setupPlayer(DataUtils.getCurrentStreamUrl(
                logic.categoryWithChannels,
                logic.categoryIndex,
                logic.channelIndex)); //准备数据播放
            Navigator.pop(context); // 退出弹窗
          }
          if(logic.settingIndex==2&&isCategoryFocused){
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return const DeviceInfoDialog();
              },
            );
          }
          return null;
        },
      ),
      BackIntent: CallbackAction<BackIntent>(
        onInvoke: (intent) {
          print('返回键被按下');
          Navigator.pop(context); // 返回上一个页面
          return null;
        },
      ),
    };
  }

  // 显示频道列表
  void showChannelList(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return FocusableActionDetector(
            autofocus: true, // 捕获焦点
            shortcuts: RemoteControlActions.shortcuts, // 复用
            actions: getActionsLeftMenu(context),
            child: ChannelListDialog());
      },
    );
  }

  void showDecoderOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return FocusableActionDetector(
            autofocus: true, // 捕获焦点
            shortcuts: RemoteControlActions.shortcuts, // 复用
            actions: getActionsRightMenu(context),
            child: DecoderOptionsDialog());
      },
    );
  }

  ///切换到上一个频道
  void switchToPreviousChannel() {
    if (logic.categoryIndex == 0 && logic.channelIndex == 0) {
      // 第一分类第一个频道，切换到最后一个分类的最后一个频道
      logic.categoryIndex = logic.categoryWithChannels.length - 1;
      logic.channelIndex =
          logic.categoryWithChannels[logic.categoryIndex].channels!.length - 1;
    } else if (logic.channelIndex == 0) {
      // 当前分类的第一个频道，切换到前一个分类的最后一个频道
      logic.categoryIndex -= 1;
      logic.channelIndex =
          logic.categoryWithChannels[logic.categoryIndex].channels!.length - 1;
    } else {
      // 当前分类内部切换频道

      logic.channelIndex > 0 ? logic.channelIndex -= 1 : null;
    }

    // 更新选中状态
    logic.selectCategory(logic.categoryWithChannels, logic.categoryIndex);
    logic.selectChannel(
        logic.categoryWithChannels[logic.categoryIndex].channels ?? [],
        logic.channelIndex);

    update();
  }

  ///切换到下一个频道
  void switchToNextChannel() {
    // 获取当前分类的频道列表
    List<ChannelWithSelection>? channels =
        logic.categoryWithChannels[logic.categoryIndex].channels;

    if (channels != null && channels.isNotEmpty) {
      // 如果当前频道是最后一个，切换到下一个分类的第一个频道
      if (logic.channelIndex == channels.length - 1) {
        // 如果已经是最后一个分类，切换回第一个分类的第一个频道
        if (logic.categoryIndex == logic.categoryWithChannels.length - 1) {
          logic.categoryIndex = 0; // 回到第一个分类
        } else {
          logic.categoryIndex += 1; // 切换到下一个分类
        }
        logic.channelIndex = 0; // 切换到新分类的第一个频道
      } else {
        // 否则切换到下一个频道
        logic.channelIndex += 1;
      }

      // 更新选中的分类和频道
      logic.selectCategory(logic.categoryWithChannels, logic.categoryIndex);
      logic.selectChannel(channels, logic.channelIndex);
    }
  }

  ///保存当前下标
  void saveCurrentSelection() {
    if (logic.previousCategoryIndex == null &&
        logic.previousChannelIndex == null) {
      logic.previousCategoryIndex = logic.categoryIndex;
      logic.previousChannelIndex = logic.channelIndex;
    }
  }

  ///清除记录
  void deleteCurrentSelection() {
    logic.previousCategoryIndex = null;
    logic.previousChannelIndex = null;
  }
}
