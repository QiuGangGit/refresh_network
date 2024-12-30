import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
          child: IgnorePointer(
            ignoring: true,
            child: Container(color: Colors.transparent),
          ),
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
                // 右侧内容（解码选项）
                _buildDecoderOptions(context, halfWidth),
                // 左侧分类（直播源 / 解码选项）
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
      builder: (_) {
        List<String> currentChannels = Get.find<LiveStreamController>()
            .selectedIndex == 0
            ? Get.find<LiveStreamController>().sourceChannels
            : Get.find<LiveStreamController>().sourceDecodingChannels;

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
                    Get.back(); // 关闭对话框
                  },
                  child: Container(
                    height: 35,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        currentChannels[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
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
          width: width,
          height: double.infinity,
          color: const Color(0x99111A28),
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildCategoryItem("直播源", 0, logic),
              _buildCategoryItem("视频解码", 1, logic),
            ],
          ),
        );
      },
    );
  }

  // 单个分类项
  Widget _buildCategoryItem(String title, int index, LiveStreamController logic) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        logic.selectedIndex = index;
        logic.update();
      },
      child: Container(
        color: logic.selectedIndex == index ? const Color(0xFFE65100) : Colors.transparent,
        height: 30.w,
        padding: EdgeInsets.only(right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
              ),
            ),
            Text(
              index == 0 ? "源1" : "硬解码",
              style: TextStyle(
                color: Colors.white,
                fontSize: 6.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
