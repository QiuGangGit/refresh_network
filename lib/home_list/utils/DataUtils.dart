import '../bean/ChannelBean.dart';
import '../bean/category_with_channels.dart';
import '../bean/channel_with_selection.dart';

class DataUtils{

  /// 转换方法: 将一维数组转换为 List<CategoryWithChannels>
  static List<CategoryWithChannels> organizeChannelData(
      List<ChannelBean> channelList) {
    // 使用 Map 按分类 ID 分组
    Map<int, CategoryWithChannels> categoryMap = {};

    for (var channel in channelList) {
      int sort = channel.sort ?? 0;
      String categoryName = channel.categoryName ?? "未分类";

      // 如果分类不存在，则初始化
      if (!categoryMap.containsKey(sort)) {
        categoryMap[sort] = CategoryWithChannels(
          sort: sort,
          categoryName: categoryName,
          channels: [],
        );
      }

      // 将频道加入对应分类
      categoryMap[sort]?.channels?.add(ChannelWithSelection(
        sort: channel.sort,
        channelName: channel.channelName,
        categoryName: channel.categoryName,
        channelNumber: channel.channelNumber,
        channelSource: channel.channelSource?.split(',').map((e) => e.trim()).toList(),
        channelStatus: channel.channelStatus,
      ));
    }

    // 返回 List<CategoryWithChannels> 并按 sort 排序
    return categoryMap.values.toList()
      ..sort((a, b) => (a.sort ?? 0).compareTo(b.sort ?? 0));
  }


  static List sortChannelCategory( List<ChannelBean> listChannelBean){
    // 1. 按 sort 排序
    listChannelBean.sort((a, b) => a.sort!.compareTo(b.sort!));

    // 2. 去重，只保留每个 sort 的第一个 categoryName
    final Map<int, String> sortCategoryMap = {};
    for (var item in listChannelBean!) {
      final sort = item.sort!;
      if (!sortCategoryMap.containsKey(sort)) {
        sortCategoryMap[sort] = item.categoryName??"";
      }
    }

    // 3. 将结果转为 List，按 sort 顺序存放
    return sortCategoryMap.entries
        .map((entry) => {"sort": entry.key, "categoryName": entry.value})
        .toList();

  }
  static List<String> parseChannelSource(String? channelSource) {
    if (channelSource == null || channelSource.isEmpty) {
      return []; // 返回空列表
    }
    return channelSource.split(',').map((url) => url.trim()).where((url) => url.isNotEmpty).toList();
  }

  static List<ChannelBean> getChildChannel(List<ChannelBean> listChannelBean,int selectedIndex) {
    return
        listChannelBean.where((item) => item.sort == selectedIndex).toList();
  }
}