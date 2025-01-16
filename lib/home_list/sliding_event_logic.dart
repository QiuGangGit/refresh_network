import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:refresh_network/home_list/utils/RemoteControlActions.dart';
import 'package:refresh_network/home_list/widget/channel_list_widget.dart';
import 'package:refresh_network/home_list/widget/decoder_options_widget.dart';

import 'bean/channel_with_selection.dart';
import 'logic.dart';

mixin SlidingEventLogic on GetxController {
  LiveStreamController get logic => Get.find<LiveStreamController>();
  // 主页面的遥控器 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsMine(BuildContext context) {
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, true); // 切换到上一个频道
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, false); // 切换到下一个频道
          return null;
        },
      ),
      OpenLeftDrawerIntent: CallbackAction<OpenLeftDrawerIntent>(
        onInvoke: (intent) {
          print('打开左侧弹窗');
          showChannelList(context); // 打开左侧菜单
          return null;
        },
      ),
      OpenRightDrawerIntent: CallbackAction<OpenRightDrawerIntent>(
        onInvoke: (intent) {
          print('打开右侧弹窗');
          showDecoderOptions(context); // 打开右侧菜单
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
          Navigator.pop(context); // 返回上一个页面
          return null;
        },
      ),
    };
  }
  // 左侧弹窗选择频道的遥控器事件 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsLeftMenu(BuildContext context) {
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, true); // 切换到上一个频道
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, false); // 切换到下一个频道
          return null;
        },
      ),
      OpenLeftDrawerIntent: CallbackAction<OpenLeftDrawerIntent>(
        onInvoke: (intent) {
          print('打开左侧弹窗');
          showChannelList(context); // 打开左侧菜单
          return null;
        },
      ),
      OpenRightDrawerIntent: CallbackAction<OpenRightDrawerIntent>(
        onInvoke: (intent) {
          print('打开右侧弹窗');
          showDecoderOptions(context); // 打开右侧菜单
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
          Navigator.pop(context); // 返回上一个页面
          return null;
        },
      ),
    };
  }
  // 右侧弹窗选择频道的遥控器事件 获取按键映射的 Actions
  Map<Type, Action<Intent>> getActionsRightMenu(BuildContext context) {
    return {
      MoveUpIntent: CallbackAction<MoveUpIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, true); // 切换到上一个频道
          return null;
        },
      ),
      MoveDownIntent: CallbackAction<MoveDownIntent>(
        onInvoke: (intent) {
          logic.switchChannel(logic.categoryWithChannels, false); // 切换到下一个频道
          return null;
        },
      ),
      OpenLeftDrawerIntent: CallbackAction<OpenLeftDrawerIntent>(
        onInvoke: (intent) {
          print('打开左侧弹窗');
          showChannelList(context); // 打开左侧菜单
          return null;
        },
      ),
      OpenRightDrawerIntent: CallbackAction<OpenRightDrawerIntent>(
        onInvoke: (intent) {
          print('打开右侧弹窗');
          showDecoderOptions(context); // 打开右侧菜单
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
          Navigator.pop(context); // 返回上一个页面
          return null;
        },
      ),
    };
  }
  // 显示频道列表
  void showChannelList(BuildContext context) {
    bool isCategoryFocused = true; // 焦点是否在分类列表
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return FocusableActionDetector(
            autofocus: true, // 捕获焦点
            shortcuts: RemoteControlActions.shortcuts, // 复用
            actions: <Type, Action<Intent>>{
              MoveUpIntent: CallbackAction<MoveUpIntent>(
                onInvoke: (intent) {
                  if (isCategoryFocused) {
                    logic.clickLeftMenuCategory(logic.categoryIndex==0?logic.categoryWithChannels.length-1:logic.categoryIndex-1);
                  } else {
                    List<ChannelWithSelection>? channels=logic.categoryWithChannels[logic.categoryIndex].channels;
                    if(logic.categoryIndex==0){
                      logic.channelIndex = logic.channelIndex==0?channels!.length-1:logic.channelIndex-1; // 当前频道索引
                    }else{

                    }

                    // 更新选中状态
                    logic.selectCategory(logic.categoryWithChannels, logic.categoryIndex);
                    logic.selectChannel(
                        logic.categoryWithChannels[logic.categoryIndex].channels ?? [], logic.channelIndex);
                    logic.update();
                  }
                  update(); // 刷新UI
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
                  update(); // 刷新UI
                  return null;
                },
              ),
              MoveLeftIntent: CallbackAction<MoveLeftIntent>(
                onInvoke: (intent) {
                  // 切换焦点到分类列表
                  isCategoryFocused = true;
                  update(); // 刷新UI
                  return null;
                },
              ),
              MoveRightIntent: CallbackAction<MoveRightIntent>(
                onInvoke: (intent) {
                  // 切换焦点到子分类列表
                  isCategoryFocused = false;
                  update(); // 刷新UI
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