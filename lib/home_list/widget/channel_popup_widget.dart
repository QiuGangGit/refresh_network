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
      String channelNumber = categoryWithChannels
          .channels![logic.channelIndex].channelNumber
          .toString();
      String channelName = categoryWithChannels
          .channels![logic.channelIndex].channelName
          .toString();

      return logic.showChannelPopup
          ? Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * 0.5 - (280.w / 2),
              right: MediaQuery.of(context).size.width * 0.5 - (280.w / 2),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 280,
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 左侧频道号
                    Text(
                      channelNumber,
                      style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(width: 16.w),
                    // 中间频道名称
                    Expanded(
                      child: Text(
                        channelName,
                        style: TextStyle(
                            fontSize: 18.sp,
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
                                color: Colors.white, size: 20.w),
                            SizedBox(height: 4.w),
                            Text("频道",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white)),
                          ],
                        ),
                        SizedBox(width: 16.0),
                        // 换台按钮
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.swap_vert,
                                color: Colors.white, size: 20.w),
                            SizedBox(height: 4.w),
                            Text("换台",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white)),
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
