import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../logic.dart';

class DeviceInfoDialog extends StatelessWidget {
  const DeviceInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<LiveStreamController>(
      builder: (logic) {
        return Stack(
          children: [
            // Positioned.fill(
            //   child: IgnorePointer(
            //     ignoring: true,
            //     child: Container(color: Color(0xFF111A28),),
            //   ),
            // ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Color(0xFF111A28),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    width: width,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "品牌:${logic.androidInfo.brand}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "型号:${logic.androidInfo.device}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "系统版本:${logic.androidInfo.version}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "软件版本:${1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "插件版本:${1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "无线MAC:${1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        ),
                        Text(
                          "有线MAC:${1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

  }
}
