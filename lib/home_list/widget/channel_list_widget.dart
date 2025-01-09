import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic.dart';

class ChannelListDialog extends StatelessWidget {
  const ChannelListDialog({super.key});

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
          left: 0,
          top: 0,
          bottom: 0,
          width: halfWidth,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                // 左侧分类部分
                _buildCategoryList(context, quarterWidth),
                // 右侧频道列表部分
                _buildChannelList(context),
              ],
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            height: 80.w,
            margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height-30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // 上方透明
                  Colors.black.withOpacity(0.7), // 下方黑色
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50.w),
                    child: Text("version:1.0.0",style: TextStyle(
                      color:  Colors.white,
                      fontSize: 9,
                    )),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 120.w),
                    child: Row(
                      children: [
                        Text("当前播放频道:佳木斯综合",style: TextStyle(
                    color:  Colors.white,
                      fontSize: 9,
                    )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 左侧分类菜单部分
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
              _buildCategoryItem("中央频道", 0, logic),
              _buildCategoryItem("卫视频道", 1, logic),
              _buildCategoryItem("本地频道", 2, logic),
            ],
          ),
        );
      },
    );
  }

  // 单个分类项
  Widget _buildCategoryItem(
      String title, int index, LiveStreamController logic) {
    return ListTile(
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: logic.selectedIndex == index
                ? const Color(0xFFE65100)
                : Colors.white,
            fontSize: 9.sp,
          ),
        ),
      ),
      onTap: () {
        logic.selectedIndex = index;
        logic.update();
      },
    );
  }

  // 右侧频道列表部分
  Widget _buildChannelList(BuildContext context) {
    return GetBuilder<LiveStreamController>(
      builder: (logic) {
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: logic.getCurrentChannels()?.length ?? 0,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back(); // 关闭频道列表
                },
                child: Container(
                  height: 25.w,
                  color: index == 0
                      ? const Color(0xFFE65100)
                      : const Color(0x80132034),
                  child: Center(
                    child: Text(
                      logic.getCurrentChannels()![index],
                      style: TextStyle(
                        color: logic.selectedIndex == 1
                            ? const Color(0xFFE65100)
                            : Colors.white,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
