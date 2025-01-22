import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:refresh_network/home_list/widget/device_info_widget.dart';

import '../logic.dart';

class DecoderOptionsDialog extends StatelessWidget {
  const DecoderOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double halfWidth = width / 2;
    double quarterWidth = width / 4;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
              onTap: (){
                Get.find<LiveStreamController>().restorePreviousSelection();
                Get.back();
              },
              child: Container(color: Colors.transparent)),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: halfWidth,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧内容（解码选项）
                _buildDecoderOptions(context, halfWidth),
                // 右侧分类（直播源 / 解码选项）
                _buildCategoryList(context, quarterWidth),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 右侧解码选项列表
  Widget _buildDecoderOptions(BuildContext context, double width) {
    return GetBuilder<LiveStreamController>(
      builder: (logic) {
        List<String> channelSourceList = logic
                .categoryWithChannels[logic.categoryIndex]
                .channels![logic.channelIndex]
                .channelSource ??
            [];
        List<String> currentChannels = logic.settingIndex == 0
            ? channelSourceList
            : logic.sourceDecodingChannels;
        return Expanded(
          child: Container(
            color: const Color(0x80132034),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 50.w),
            child: ListView.builder(
              itemCount: currentChannels.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    logic.settingIndex == 0
                        ? logic
                            .categoryWithChannels[logic.categoryIndex]
                            .channels![logic.channelIndex]
                            .currentSourceIndex = index
                        : logic.decodeIndex = index;
                    Get.back(); // 关闭对话框
                  },
                  child: Container(
                    height: 35,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: (logic.settingIndex == 0 &&
                                logic
                                        .categoryWithChannels[
                                            logic.categoryIndex]
                                        .channels![logic.channelIndex]
                                        .currentSourceIndex ==
                                    index) ||
                            (logic.settingIndex == 1 &&
                                logic.decodeIndex == index)
                        ? Colors.red
                        : Color(0x80132034),
                    child: Center(
                      child: Text(
                        logic.settingIndex == 0
                            ? "源${index + 1}"
                            : currentChannels[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // 左侧分类菜单（直播源 / 解码选项）
  Widget _buildCategoryList(BuildContext context, double width) {
    return GetBuilder<LiveStreamController>(
      builder: (logic) {
        return Container(
          height: double.infinity,
          width: width,
          color: const Color(0x99111A28),
          child: Column(
            children: [
              Container(
                height: 20.w,
                child: Center(
                  child: Text("设置",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.sp,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Container(
                  height: 0.5.w,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  width: width,
                  // color: const Color(0x99111A28),
                  alignment: Alignment.center,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildCategoryItem("直播源", 0, logic),
                      _buildCategoryItem("视频解码", 1, logic),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showDeviceInfo(context);
                },
                child: Text(
                  "系统信息",
                  style: TextStyle(
                      fontSize: 6.sp,
                      color: logic.settingIndex==2?Colors.deepOrange:Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: logic.settingIndex==2?Colors.deepOrange:Colors.white,
                      decorationThickness: 1.0),
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
            ],
          ),
        );
      },
    );
  }

  // 单个分类项
  Widget _buildCategoryItem(
      String title, int index, LiveStreamController logic) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        logic.settingIndex = index;
        logic.update();
      },
      child: Container(
        color: logic.settingIndex == index
            ? const Color(0xFFE65100)
            : Colors.transparent,
        height: 20.w,
        padding: EdgeInsets.only(right: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 6.sp,
              ),
            ),
            // Text(
            //   index == 0 ? "源1" : "硬解码",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 6.sp,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void showDeviceInfo(BuildContext context) async{

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return  DeviceInfoDialog();
      },
    );
  }
}
