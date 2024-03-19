import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'page_controller.dart';
import 'page_state.dart';

Widget buildRefreshWidget({
  required Widget Function() builder,
  VoidCallback? onRefresh,
  VoidCallback? onLoad,
  required RefreshController refreshController,
  bool enablePullUp = true,
  bool enablePullDown = true
}) {
  return SmartRefresher(
    enablePullUp: enablePullUp,
    enablePullDown: enablePullDown,
    controller: refreshController,
    onRefresh: onRefresh,
    onLoading: onLoad,
    // header: CustomHeader(
    //   builder: (BuildContext context, RefreshStatus? mode) {
    //
    //   },
    // ),
    header: const ClassicHeader(idleText: "下拉刷新",
      releaseText: "松开刷新",
      completeText: "刷新完成",
      refreshingText: "加载中......",),
    footer: const ClassicFooter(idleText: "上拉加载更多",
      canLoadingText: "松开加载更多",
      loadingText: "加载中......", noDataText: "我是有底线的",),
    child: builder(),
  );
}

Widget buildRefreshViewWidget<T, C extends PagingController<T, PagingState<T>>>(
    {
      required Widget Function(List<T> item) builder,
      bool enablePullUp = true,
      bool enablePullDown = true,
      String? tag,
      Color? emptyColor
    }) {
  C controller = Get.find(tag: tag);
  return GetBuilder<C>(builder: (controller) {
    return controller.pagingState.isShowLoading ? loadingWidget() : controller.pagingState.data.isEmpty ? emptyWidget(textColor: emptyColor) : buildRefreshWidget(
      builder: () =>
          builder.call(controller.pagingState.data),
      refreshController: controller.refreshController,
      onRefresh: controller.refreshData,
      onLoad: controller.loadMoreData,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp && controller.pagingState.hasMore,
    );
  }, tag: tag, id: controller.pagingState.refreshId,);
}
Widget buildRefreshListWidget<T, C extends PagingController<T, PagingState<T>>>(
    {
      required Widget Function(T item, int index) itemBuilder,
      bool enablePullUp = true,
      bool enablePullDown = true,
      String? tag,
      Widget Function(T item, int index)? separatorBuilder,
      Function(T item, int index)? onItemClick,
      ScrollPhysics? physics,
      bool shrinkWrap = false,
      Axis scrollDirection = Axis.vertical,
      Color? emptyColor,
      String? emptyImage,
      String? emptyText,
      double? emptySize,
    }) {
  C controller = Get.find(tag: tag);
  return GetBuilder<C>(builder: (controller) {
    return controller.pagingState.isShowLoading ? loadingWidget() : controller.pagingState.data.isEmpty ? emptyWidget(textColor: emptyColor, text: emptyText, imgName: emptyImage, emptySize: emptySize) : buildRefreshWidget(
      builder: () =>
          buildListView<T>(
              data: controller.pagingState.data,
              separatorBuilder: separatorBuilder,
              itemBuilder: itemBuilder,
              onItemClick: onItemClick,
              physics: physics,
              shrinkWrap: shrinkWrap,
              scrollDirection: scrollDirection
          ),
      refreshController:controller.refreshController,
      onRefresh: controller.refreshData,
      onLoad: controller.loadMoreData,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp && controller.pagingState.hasMore,
    );
  }, tag: tag, id: controller.pagingState.refreshId,);
}
///通用空页面
Widget emptyWidget({Color bgColor = Colors.transparent, String? text, String? imgName, double? emptySize, Color? textColor, double? spacing}) {
  return Container(
    color: bgColor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(width: 128.w,height: 128.w,color: Colors.green,),
          SizedBox(height: spacing ?? 20.w,),
          Text(text ?? "暂无内容", style: TextStyle(
            fontSize: 14.sp,
            color: textColor ?? Colors.white.withOpacity(0.33),
          ), textAlign: TextAlign.center,),
        ],
      ),
    ),
  );
}

Widget buildListView<T>(
    {required Widget Function(T item, int index) itemBuilder,
      required List<T> data,
      Widget Function(T item, int index)? separatorBuilder,
      Function(T item, int index)? onItemClick,
      ScrollPhysics? physics,
      bool shrinkWrap = false,
      Axis scrollDirection = Axis.vertical}) {
  return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.zero,
      scrollDirection: scrollDirection,
      itemBuilder: (ctx, index) =>
          GestureDetector(
            child: itemBuilder.call(data[index], index),
            onTap: () => onItemClick?.call(data[index], index),
          ),
      separatorBuilder: (ctx, index) =>
      separatorBuilder?.call(data[index], index) ?? Container(),
      itemCount: data.length);
}
Widget loadingWidget({Color bgColor = Colors.transparent}) {
  return Container(
    color: bgColor,
    child: Center(
      child: SizedBox(
        width: 200.w,
        height: 200.w,
        child: Center(
            ),
      ),
    ),
  );
}
///scrollview去除蓝色回弹效果
class OverScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child,
      ScrollableDetails details) {
    // TODO: implement buildOverscrollIndicator
    if (getPlatform(context) == TargetPlatform.android ||
        getPlatform(context) == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        axisDirection: details.direction,
        color: Theme
            .of(context)
            .colorScheme
            .secondary,
        child: child,
      );
    } else {
      return child;
    }
  }
}