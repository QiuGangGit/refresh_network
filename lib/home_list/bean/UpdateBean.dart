class AppUpdateBean {
  final String appversion;
  final bool isForceUpdate;
  final String appContent;
  final String appDownloadUrl;

  AppUpdateBean({
    required this.appversion,
    required this.isForceUpdate,
    required this.appContent,
    required this.appDownloadUrl,
  });

  // 从 JSON 构造 AppUpdateBean
  factory AppUpdateBean.fromJson(Map<String, dynamic> json) {
    return AppUpdateBean(
      appversion: json['appversion'],
      isForceUpdate: json['isforceupdate'] == 1,  // 将 1 转为布尔值
      appContent: json['appcontent'],
      appDownloadUrl: json['appdownurl'],
    );
  }

  // 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'appversion': appversion,
      'isforceupdate': isForceUpdate ? 1 : 0,  // 布尔值转换为 1 或 0
      'appcontent': appContent,
      'appdownurl': appDownloadUrl,
    };
  }
}