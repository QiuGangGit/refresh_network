class ChannelBean {
  ChannelBean({
      int? sort, 
      String? channelName, 
      String? categoryName, 
      int? channelNumber, 
      String? channelSource, 
      int? channelStatus,}){
    _sort = sort;
    _channelName = channelName;
    _categoryName = categoryName;
    _channelNumber = channelNumber;
    _channelSource = channelSource;
    _channelStatus = channelStatus;
}

  ChannelBean.fromJson(dynamic json) {
    _sort = json['sort'];
    _channelName = json['channelName'];
    _categoryName = json['categoryName'];
    _channelNumber = json['channelNumber'];
    _channelSource = json['channelSource'];
    _channelStatus = json['channelStatus'];
  }
  int? _sort;
  String? _channelName;
  String? _categoryName;
  int? _channelNumber;
  String? _channelSource;
  int? _channelStatus;

  int? get sort => _sort;
  String? get channelName => _channelName;
  String? get categoryName => _categoryName;
  int? get channelNumber => _channelNumber;
  String? get channelSource => _channelSource;
  int? get channelStatus => _channelStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sort'] = _sort;
    map['channelName'] = _channelName;
    map['categoryName'] = _categoryName;
    map['channelNumber'] = _channelNumber;
    map['channelSource'] = _channelSource;
    map['channelStatus'] = _channelStatus;
    return map;
  }

}