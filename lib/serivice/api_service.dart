import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../home_list/bean/AppInitBean.dart';
import '../home_list/bean/ChannelBean.dart';
import '../home_list/bean/UpdateBean.dart';
import '../request/api_config.dart';
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

  ///授权检验
  static Future<BaseResponse?> appAuthExpireCheck(String deviceId) async {
    dynamic value = await requestClient
        .post(APIS.appAuthExpireCheck, data: {"deviceId": deviceId});
    final response = BaseResponse.fromJsons(value);
    return response.data;
  }

  ///设备在线和离线
  static Future<BaseResponse?> appHotelDeviceOnline(
      String deviceId, String deviceOnlineStatus) async {
    dynamic value = await requestClient.post(APIS.appHotelDeviceOnline,
        data: {"deviceId": deviceId, "deviceOnlineStatus": deviceOnlineStatus});
    final response = BaseResponse.fromJsons(value);
    return response;
  }

  ///app更新设备
  static Future<AppUpdateBean?> appVersionCheck(String version) async {
    dynamic value = await requestClient.post(APIS.appVersionCheck, data: {
      "version": version,
    });
    final response = BaseResponse<AppUpdateBean>.fromJson(
      value,
      (json) => AppUpdateBean.fromJson(json),
    );
    return response.data;
  }
  ///获取小程序token
  static Future<String?> getAccessToken() async {
    final String url = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=${ApiConfig.appId??""}&secret=${ApiConfig.appSecret??""}';

    try {
      Dio dio = Dio();
      final response = await dio.get(url);

      // 打印响应内容
      print("Response data: ${response.data}");

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        // 获取 access_token
        String accessToken = response.data['access_token'];
        return accessToken;
      } else {
        // 错误处理
        print("获取 access_token 失败: ${response.data['errmsg']}");
        return null;
      }
    } catch (e) {
      print('请求失败: $e');
      return null;
    }
  }

  // 生成二维码
  static Future<String?> generateQRCode(String deviceId,String accessToken) async {
    // 微信生成二维码的接口
    final String url = 'https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=$accessToken';

    // 构造请求体
    final Map<String, dynamic> requestData = {
      "action_name": "QR_LIMIT_STR_SCENE", // 永久二维码
      "action_info": {
        "scene": {
          "scene_str": "deviceId=$deviceId"  // 使用 deviceId 作为参数
        }
      }
    };

    try {
      // 创建 Dio 实例
      Dio dio = Dio();
      // 发送 POST 请求
      final response = await dio.post(url, data: requestData);

      // 打印响应内容
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // 获取二维码的 ticket
        String ticket = response.data['ticket'];
        print('二维码 ticket: $ticket');
        // 生成二维码的 URL
        String qrUrl = 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=$ticket';
        print('二维码 URL: $qrUrl');
        return ticket;
        // 你可以在这里将 qrUrl 用于展示二维码
      } else {
        print('生成二维码失败: ${response.data['errmsg']}');
        return null;
      }
    } catch (e) {
      print('请求失败: $e');
      return null;
    }
  }
}

