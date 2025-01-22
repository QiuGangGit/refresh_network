import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:refresh_network/request/api_config.dart';
import 'package:refresh_network/serivice/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_list/bean/AppInitBean.dart';
import '../request/base_response.dart';
import '../route.dart';

class LoginLogic extends GetxController {
  String qrCodeUrl = "";
  String miniProgramUrl = ""; //二维码链接
  Timer? loginCheckTimer; // 定时器
  Timer? _timer; // 定时器

  @override
  void onInit() {
    super.onInit();
    getNetWork();
  }

  getNetWork() async {
    final prefs = await SharedPreferences.getInstance();
    String qrCodeUrl = prefs.getString('qrCodeUrl') ?? 'default_value';
    String brand = prefs.getString('brand') ?? 'default_value';

    ///获取小程序token
    String? accessToken = await ApiService.getAccessToken();

    ///获取小程序ticket
    String? ticket =
        await ApiService.generateQRCode(qrCodeUrl, accessToken ?? "");

    ///生成二维码链接
    String currentVersion = await getAppVersion(); // 当前版本号
   // 构造普通链接
    miniProgramUrl =
        '${ApiConfig.baseUrl}?deviceId=$qrCodeUrl&deviceVersion=$currentVersion&deviceModel=$brand';
    await ApiService.appInit();
    List<AppInitBean>? listInit = await ApiService.appInit();
    saveAppInitBeans(listInit);

    ///我需要轮训鉴权接口然后
    /// 开始定时轮询
    startLoginStatusCheck();
  }
  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel(); // 取消定时器，停止轮询
    }
    super.dispose();
  }

  ///存储初始化数据
  Future<void> saveAppInitBeans(List<AppInitBean>? beans) async {
    if (beans == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    // 将 List<AppInitBean> 转换为 JSON 字符串
    final List<Map<String, dynamic>> jsonList =
        beans.map((bean) => bean.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);

    // 存储到 SharedPreferences
    await prefs.setString('appInitBeans', jsonString);
    print('数据已保存: $jsonString');
  }

  @override
  void onClose() {
    loginCheckTimer?.cancel();
    super.onClose();
  }

  void startLoginStatusCheck() {
    // 启动定时器，每 2 秒检查一次登录状态
    loginCheckTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        // 调用鉴权接口
        BaseResponse? baseResponse = await ApiService.appAuthExpireCheck(qrCodeUrl);

        // 判断鉴权是否成功
        if (baseResponse?.code == 0) {
          // 鉴权成功，跳转到首页并停止定时器
          Get.offAndToNamed(Routes.home);
          loginCheckTimer?.cancel(); // 停止定时器
        } else {
          // 鉴权失败，重新开始 2 秒的鉴权检查
          print('鉴权失败，重新开始检查...');
          // 取消当前定时器，避免重复执行
          loginCheckTimer?.cancel();
          // 重新启动定时器
          startLoginStatusCheck();
        }
      } catch (e) {
        // 捕获异常并处理
        print('网络请求失败: $e');
        // 处理异常后的逻辑，比如显示错误提示
        Get.snackbar('错误', '网络请求失败，请检查网络连接');
        // 重新启动定时器，以便继续尝试请求
        startLoginStatusCheck(); // 重新启动定时器
      }
    });
  }

  // 登录成功跳转到主页面
  void onLoginSuccess() {
    Get.offAndToNamed(Routes.home);
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // 获取当前应用的版本
  }
}
