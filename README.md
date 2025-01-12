# refresh_network

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
///获取存储的InitData
// ///获取存储的Initbean数据
// Future<Map<String, AppInitBean>> loadAppInitBeansAsMap() async {
//   final prefs = await SharedPreferences.getInstance();
//
//   // 从 SharedPreferences 中读取 JSON 字符串
//   final String? jsonString = prefs.getString('appInitBeans');
//
//   if (jsonString != null) {
//     // 将 JSON 字符串解析为 List<AppInitBean>
//     final List<dynamic> jsonList = jsonDecode(jsonString);
//     final List<AppInitBean> beans = jsonList.map((json) => AppInitBean.fromJson(json)).toList();
//
//     // 转换为 Map<String, AppInitBean>，以 key 为键
//     final Map<String, AppInitBean> beanMap = {
//       for (var bean in beans) bean.key!: bean
//     };
//
//     return beanMap;
//   }
//
//   return {}; // 如果没有数据，返回空 Map
// }
//
// // 加载数据为 Map
// final Map<String, AppInitBean> beanMap = await loadAppInitBeansAsMap();
//
// // 示例：根据 key 获取对应的 value 和 name
// final String searchKey = "ServicePhone";
//
// if (beanMap.containsKey(searchKey)) {
// final AppInitBean bean = beanMap[searchKey]!;
// print('Key: ${bean.key}, Value: ${bean.value}, Name: ${bean.name}');
// } else {
// print('Key $searchKey not found.');
// }