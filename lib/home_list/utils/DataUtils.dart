import '../bean/ChannelBean.dart';
import '../bean/category_with_channels.dart';
import '../bean/channel_with_selection.dart';

class DataUtils {
  /// 转换方法: 将一维数组转换为 List<CategoryWithChannels>
  ///
  static List<CategoryWithChannels> organizeChannelData(
      List<ChannelBean> channelList) {
    // 使用 Map 按 categoryName 进行分组
    Map<String, CategoryWithChannels> categoryMap = {};

    for (var channel in channelList) {
      String categoryName = channel.categoryName ?? "未分类";

      // 如果分类不存在，则初始化
      if (!categoryMap.containsKey(categoryName)) {
        categoryMap[categoryName] = CategoryWithChannels(
          categoryName: categoryName,
          channels: [],
        );
      }

      // 将频道加入对应分类
      categoryMap[categoryName]?.channels?.add(ChannelWithSelection(
        sort: channel.sort,
        channelName: channel.channelName,
        categoryName: channel.categoryName,
        channelNumber: channel.channelNumber,
        channelSource:
        channel.channelSource?.split(',').map((e) => e.trim()).toList(),
        channelStatus: channel.channelStatus,
      ));
    }

    // 返回 List<CategoryWithChannels> 并按 categoryName 排序
    return categoryMap.values.toList()
      ..sort((a, b) => (a.categoryName ?? "").compareTo(b.categoryName ?? ""));
  }
  // static List<CategoryWithChannels> organizeChannelData(
  //     List<ChannelBean> channelList) {
  //   // 使用 Map 按分类 ID 分组
  //   Map<int, CategoryWithChannels> categoryMap = {};
  //
  //   for (var channel in channelList) {
  //     int sort = channel.sort ?? 0;
  //     String categoryName = channel.categoryName ?? "未分类";
  //
  //     // 如果分类不存在，则初始化
  //     if (!categoryMap.containsKey(sort)) {
  //       categoryMap[sort] = CategoryWithChannels(
  //         sort: sort,
  //         categoryName: categoryName,
  //         channels: [],
  //       );
  //     }
  //
  //     // 将频道加入对应分类
  //     categoryMap[sort]?.channels?.add(ChannelWithSelection(
  //           sort: channel.sort,
  //           channelName: channel.channelName,
  //           categoryName: channel.categoryName,
  //           channelNumber: channel.channelNumber,
  //           channelSource:
  //               channel.channelSource?.split(',').map((e) => e.trim()).toList(),
  //           channelStatus: channel.channelStatus,
  //         ));
  //   }
  //
  //   // 返回 List<CategoryWithChannels> 并按 sort 排序
  //   return categoryMap.values.toList()
  //     ..sort((a, b) => (a.sort ?? 0).compareTo(b.sort ?? 0));
  // }

  static String getCurrentStreamUrl(
      List<CategoryWithChannels>? categoryWithChannels,
      int categoryIndex,
      int channelIndex) {
    // 获取当前分类和频道
    var currentCategory = categoryWithChannels?[categoryIndex];
    var currentChannel = currentCategory?.channels?[channelIndex];

    // 如果分类或频道为空，返回空字符串
    if (currentChannel == null) {
      return "";
    }

    // 根据 currentSourceIndex 获取当前播放的 URL
    int currentSourceIndex = currentChannel.currentSourceIndex;
    var channelSources = currentChannel.channelSource;

    if (channelSources == null ||
        currentSourceIndex < 0 ||
        currentSourceIndex >= channelSources.length) {
      return ""; // 索引无效或频道源为空
    }

    return channelSources[currentSourceIndex];
  }
}
