import '../bean/ChannelBean.dart';

class DataUtils{
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
}