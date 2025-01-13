import 'channel_with_selection.dart';

class CategoryWithChannels {
  int? sort; // 分类的 sort
  String? categoryName; // 分类名称
  List<ChannelWithSelection>? channels; // 分类下的频道列表
  bool isSelect; // 分类是否选中

  CategoryWithChannels({
    this.sort,
    this.categoryName,
    this.channels,
    this.isSelect = false, // 默认未选中
  });

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'sort': sort,
      'categoryName': categoryName,
      'isSelect': isSelect,
      'channels': channels?.map((channel) => channel.toJson()).toList(),
    };
  }
}