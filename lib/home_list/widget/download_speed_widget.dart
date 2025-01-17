import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../logic.dart';

class DownloadSpeedIndicator extends StatelessWidget {
  const DownloadSpeedIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveStreamController>(builder: (controller) {
      return Positioned(
        top: 20.0,
        right: 80.0,
        child: controller.isBuffering&&controller.downloadSpeed>0
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.0.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Speed: ${controller.downloadSpeed.toStringAsFixed(1)} KB/s',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        )
            : const SizedBox.shrink(), // 当不缓冲时不显示
      );
    });
  }
}