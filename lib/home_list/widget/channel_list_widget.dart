import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bean/category_with_channels.dart';
import '../bean/channel_with_selection.dart';
import '../logic.dart';
import '../utils/DataUtils.dart';

class ChannelListDialog extends StatelessWidget {
  const ChannelListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double halfWidth = width / 2;
    double quarterWidth = width / 4;
    CategoryWithChannels categoryWithChannels=Get.find<LiveStreamController>().categoryWithChannels[Get.find<LiveStreamController>().categoryIndex];
    String channelName=categoryWithChannels.channels![Get.find<LiveStreamController>().channelIndex].channelName.toString();
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Get.back();
                },
                child: Container(color: Colors.transparent)),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: halfWidth,
          child: WillPopScope(
            onWillPop: () async {
              // 返回按钮被点击时执行的逻辑
              print("用户点击了返回按钮或触发了返回手势");
              Get.find<LiveStreamController>().restorePreviousSelection();
              return true; // 返回 true 允许页面返回，返回 false 阻止页面返回
            },
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
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            height: 80.w,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height - 30),
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
                    child: Text("version:1.0.0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        )),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 120.w),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.play_arrow_solid,
                          color: Color(0xFFE65100), // 设置颜色为黄色
                          size: 20.w, // 图标大小
                        ),
                        SizedBox(width: 2.w,),
                        Text("当前播放频道:${channelName}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
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
            children: logic.categoryWithChannels
                .asMap()
                .entries
                .map((entry) => _buildCategoryItem(
                    entry.value.categoryName ?? "",
                    entry.value.isSelect,
                    entry.key, // 索引
                    logic))
                .toList(),
          ),
        );
      },
    );
  }

  // 单个分类项
  Widget _buildCategoryItem(
      String title, bool isSelect, int index, LiveStreamController logic) {
    return ListTile(
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelect ? const Color(0xFFE65100) : Colors.white,
            fontSize: 9.sp,
          ),
        ),
      ),
      onTap: () {
        logic.clickLeftMenuCategory(index);
      },
    );
  }

  // 右侧频道列表部分
  Widget _buildChannelList(BuildContext context) {
    return GetBuilder<LiveStreamController>(
      builder: (logic) {
        List<ChannelWithSelection> channels =
            logic.categoryWithChannels[logic.categoryIndex].channels ?? [];
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: channels.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  //切换选台
                  logic.clickRightChannel(index); // 关闭频道列表
                },
                child: Container(
                  height: 25.w,
                  color: channels[index].isSelect
                      ? const Color(0xFFE65100)
                      : const Color(0x80132034),
                  child: Center(
                    child: Text(
                      channels[index].channelName ?? "",
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
        );
      },
    );
  }
}
