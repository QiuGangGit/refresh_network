import 'package:get/get.dart';

import '../home_list/bean/AppInitBean.dart';
import '../home_list/bean/ChannelBean.dart';
import '../request/apis.dart';
import '../request/base_response.dart';
import '../request/request_client.dart';

class ApiService extends GetxService {
  ApiService._();

  static init() {
    Get.put<ApiService>(ApiService._(), permanent: true);
  }

  factory ApiService() => Get.find<ApiService>();

  static Future<List<AppInitBean>?> appInit() async {
    dynamic value = await requestClient.post(
      APIS.appInit,
    );
    final response = BaseResponse<List<AppInitBean>>.fromJson(
      value,
      (json) =>
          (json as List).map((item) => AppInitBean.fromJson(item)).toList(),
    );
    return response.data;
  }

  static Future<List<ChannelBean>?> appChannelList(String deviceId) async {
    dynamic value = await requestClient
        .post(APIS.appChannelList, data: {"deviceId": deviceId});
    final response = BaseResponse<List<ChannelBean>>.fromJson(
      value,
      (json) =>
          (json as List).map((item) => ChannelBean.fromJson(item)).toList(),
    );
    return response.data;
  }
}
