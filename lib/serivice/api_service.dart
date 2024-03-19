
import 'package:get/get.dart';
import 'package:refresh_network/model/Detail.dart';

import '../request/apis.dart';
import '../request/request_client.dart';


class ApiService extends GetxService {
  ApiService._();
  static init() {
    Get.put<ApiService>(ApiService._(), permanent: true);
  }
  factory ApiService() => Get.find<ApiService>();

  Future<List<Data>?> searchUser(String key, {int page = 1}) async{
      dynamic value=await requestClient.get(APIS.searchUsers, queryParameters: {
      "page": page,
      "size": 10,
      "keyword": key
    });
    return Detail.fromJson(value).data;
  }
}