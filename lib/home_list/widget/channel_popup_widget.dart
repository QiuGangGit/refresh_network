import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../bean/category_with_channels.dart';
import '../logic.dart';

class ChannelPopupWidget extends StatelessWidget {
  const ChannelPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveStreamController>(builder: (logic) {
      if (logic.categoryWithChannels.isEmpty) {
        return Container();
      }

      CategoryWithChannels categoryWithChannels =
          logic.categoryWithChannels[logic.categoryIndex];
      String channelNumber = (categoryWithChannels.channels != null &&
          logic.channelIndex >= 0 &&
          logic.channelIndex < categoryWithChannels.channels!.length)
          ? categoryWithChannels.channels![logic.channelIndex].channelNumber?.toString() ?? ""
          : "";
      String channelName = (categoryWithChannels.channels != null &&
          logic.channelIndex >= 0 &&
          logic.channelIndex < categoryWithChannels.channels!.length)
          ? categoryWithChannels.channels![logic.channelIndex].channelName?.toString() ?? ""
          : "";

      return logic.showChannelPopup
          ? Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * 0.5 - (140.w / 2),
              right: MediaQuery.of(context).size.width * 0.5 - (140.w / 2),
              child: Container(
                margin:  EdgeInsets.only(bottom: 18.w),
                padding:  EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 10.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                width: 140.w,
                height: 45.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 左侧频道号
                    Text(
                      channelNumber,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(width: 8.w),
                    // 中间频道名称
                    Expanded(
                      child: Text(
                        channelName,
                        style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 右侧功能按钮
                    Row(
                      children: [
                        // 频道按钮
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.white, size: 10.w),
                            SizedBox(height: 2.w),
                            Text("频道",
                                style: TextStyle(
                                    fontSize: 6.sp, color: Colors.white)),
                          ],
                        ),
                        SizedBox(width: 8.w),
                        // 换台按钮
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.swap_vert,
                                color: Colors.white, size: 10.w),
                            SizedBox(height: 2.w),
                            Text("换台",
                                style: TextStyle(
                                    fontSize: 6.sp, color: Colors.white)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Container();
    });
  }
}
