
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'exception.dart';

bool handleException(ApiException exception, {bool Function(ApiException)? onError}){

  int code = exception.code ?? 0;
  if (code == 30001 || code == 30002 || code == 30003 || code == 30004 || code == 3005 ) {
    EasyLoading.showError(exception.message ?? "登录过期");
    // Get.find<UserController>().logout();
    return true;
  } else if (code == 40002) {
    EasyLoading.showError(exception.message ?? "请先完成认证");
    // AppNavigator.pushPXPage('MyVerified');
    return false;
  }

  if(onError?.call(exception) == true){
    return true;
  }

  // if(exception.code == 401 ){
  //   ///其他业务操作，比如登录过期等
  //   return true;
  // }
  EasyLoading.showError(exception.message ?? ApiException.unknownException);

  return false;
}