class ChannelWithSelection {
  int? sort; // 分类的 sort
  String? channelName; // 频道名称
  String? categoryName; // 分类名称
  int? channelNumber; // 频道编号
  List<String>? channelSource; // 频道源（多个 URL）
  int? channelStatus; // 频道状态
  bool isSelect; // 是否选中

  ChannelWithSelection({
    this.sort,
    this.channelName,
    this.categoryName,
    this.channelNumber,
    this.channelSource,
    this.channelStatus,
    this.isSelect = false, // 默认未选中
  });

  // 从原始 JSON 转换
  ChannelWithSelection.fromJson(Map<String, dynamic> json)
      : sort = json['sort'],
        channelName = json['channelName'],
        categoryName = json['categoryName'],
        channelNumber = json['channelNumber'],
        channelSource = json['channelSource'] != null
            ? (json['channelSource'] as String)
            .split(',')
            .map((s) => s.trim())
            .toList() // 根据逗号分隔
            : [],
        channelStatus = json['channelStatus'],
        isSelect = false; // 默认未选中

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'sort': sort,
      'channelName': channelName,
      'categoryName': categoryName,
      'channelNumber': channelNumber,
      'channelSource': channelSource?.join(','), // 转回逗号分隔的字符串
      'channelStatus': channelStatus,
      'isSelect': isSelect,
    };
  }
}