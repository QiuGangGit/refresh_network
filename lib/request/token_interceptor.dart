import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';


class TokenInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ///todo get token from cache
    options.headers["Authorization"] = "Bearer 375e479c-86c6-45b2-9342-be4ce5a000e1";
    // options.headers["response-status"] = 401;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}