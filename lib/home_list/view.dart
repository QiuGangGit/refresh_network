import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'logic.dart'; // 导入控制器

void main() {
  runApp(LiveStreamingApp());
}

class LiveStreamingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveStreamingPage(),
    );
  }
}

class LiveStreamingPage extends StatelessWidget {
  final LiveStreamController controller =
      Get.put(LiveStreamController()); // 初始化控制器

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 视频播放器部分
          GetBuilder<LiveStreamController>(
            builder: (_) {
              return BetterPlayer(
                controller: controller.betterPlayerController,
              );
            },
          ),

          // 左侧频道分类菜单
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onHorizontalDragEnd: (_) => showChannelList(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),

          // 右侧解码器菜单
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            top: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragEnd: (_) => showDecoderOptions(
                context,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 显示频道列表
  void showChannelList(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 透明的遮罩层，用于拦截屏幕触摸事件，防止点击穿透
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Container(color: Colors.transparent),
              ),
            ),
            // 实际的对话框内容
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    children: [
                      // 左侧分类
                      GetBuilder<LiveStreamController>(builder: (logic) {
                        return Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: double.infinity,
                          color: Color(0x99111A28),
                          //111A28
                          alignment: Alignment.center,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: Center(
                                    child: Text(
                                  "中央频道",
                                  style: TextStyle(
                                    color: Get.find<LiveStreamController>()
                                                .selectedIndex ==
                                            0
                                        ? Color(0xFFE65100)
                                        : Colors.white,
                                    fontSize: 9.sp,
                                  ),
                                )),
                                onTap: () {
                                  // 更新选中的频道分类索引为中央频道（索引为0）
                                  Get.find<LiveStreamController>()
                                      .selectedIndex = 0;
                                  // 刷新右侧频道列表
                                  Get.find<LiveStreamController>().update();
                                },
                              ),
                              ListTile(
                                title: Center(
                                    child: Text("卫视频道",
                                        style: TextStyle(
                                          color:
                                              Get.find<LiveStreamController>()
                                                          .selectedIndex ==
                                                      1
                                                  ? Color(0xFFE65100)
                                                  : Colors.white,
                                          fontSize: 9.sp,
                                        ))),
                                onTap: () {
                                  // 更新选中的频道分类索引为卫视频道（索引为1）
                                  Get.find<LiveStreamController>()
                                      .selectedIndex = 1;
                                  // 刷新右侧频道列表
                                  Get.find<LiveStreamController>().update();
                                },
                              ),
                              ListTile(
                                title: Center(
                                    child: Text("本地频道",
                                        style: TextStyle(
                                          color:
                                              Get.find<LiveStreamController>()
                                                          .selectedIndex ==
                                                      2
                                                  ? Color(0xFFE65100)
                                                  : Colors.white,
                                          fontSize: 9.sp,
                                        ))),
                                onTap: () {
                                  // 更新选中的频道分类索引为本地频道（索引为2）
                                  Get.find<LiveStreamController>()
                                      .selectedIndex = 2;
                                  // 刷新右侧频道列表
                                  Get.find<LiveStreamController>().update();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      // 右侧频道列表
                      GetBuilder<LiveStreamController>(builder: (logic) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: logic.getCurrentChannels()?.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  // 在这里处理频道切换逻辑，例如：
                                  // controller.switchChannel(index);
                                  Get.back(); // 关闭频道列表
                                },
                                child: Container(
                                  height: 25.w,
                                  // color:Color(0x80132034)
                                  color: index == 0
                                      ? Color(0xFFE65100)
                                      : Color(0x80132034),
                                  child: Center(
                                    child:
                                        Text(logic.getCurrentChannels()![index],
                                            style: TextStyle(
                                              color:
                                                  Get.find<LiveStreamController>()
                                                              .selectedIndex ==
                                                          1
                                                      ? Color(0xFFE65100)
                                                      : Colors.white,
                                              fontSize: 9.sp,
                                            )),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDecoderOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 透明的遮罩层，用于拦截屏幕触摸事件，防止点击穿透
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Container(color: Colors.transparent),
              ),
            ),
            // 实际的对话框内容
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GetBuilder<LiveStreamController>(
                          builder: (_) {
                            // 根据当前选中的分类索引，显示相应的频道列表
                            List<String> currentChannels = [];
                            if (Get.find<LiveStreamController>()
                                    .selectedIndex ==
                                0) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .sourceChannels;
                            } else if (Get.find<LiveStreamController>()
                                    .selectedIndex ==
                                1) {
                              currentChannels = Get.find<LiveStreamController>()
                                  .sourceDecodingChannels;
                            }
                            return Container(
                              color: Color(0x80132034),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 50.w),
                              child: ListView.builder(
                                itemCount: currentChannels.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      // 在这里处理选择直播源或视频解码选项后的逻辑
                                      Get.back(); // 关闭对话框
                                      // 可以根据需要添加更多具体操作，例如设置解码器等
                                    },
                                    child: Container(
                                      height: 35,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(currentChannels[index],style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.sp,
                                        ),),
                                      ),

                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: double.infinity,
                        color: Color(0x99111A28),
                        alignment: Alignment.center,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // 更新选中的分类索引为直播源（索引为0）
                                Get.find<LiveStreamController>().selectedIndex =
                                0;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                              child: Container(
                                color: Color(0xFFE65100),
                                height: 30.w,
                                padding: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "直播源",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                    Text("源1",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 6.sp,
                                        ))
                                  ],
                                ),

                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // 更新选中的分类索引为直播源（索引为0）
                                Get.find<LiveStreamController>().selectedIndex =
                                1;
                                // 刷新右侧频道列表
                                Get.find<LiveStreamController>().update();
                              },
                              child: Container(
                                height: 30.w,
                                padding: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "视频解码",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                    Text("硬解码",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 6.sp,
                                        ))
                                  ],
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
