import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:refresh_network/request/api_response.dart';
import 'package:refresh_network/request/token_interceptor.dart';
import '../model/api_response/raw_data.dart';
import 'api_config.dart';
import 'exception.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'exception_handler.dart';

RequestClient requestClient = RequestClient();

class RequestClient {
  late Dio _dio;

  RequestClient() {
    _dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: ApiConfig.connectTimeout)));
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true, requestBody: true, responseHeader: true));
  }

  Future<T?> request<T>(
    String url, {
    String method = "Get",
    bool showLoading = false,
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool Function(ApiException)? onError,
  }) async {
    if (showLoading) {
      EasyLoading.show(status: "加载中...");
    }
    try {
      Options options = Options()
        ..method = method
        ..headers = headers;

      data = _convertRequestData(data);

      Response response = await _dio.request(url,
          queryParameters: queryParameters, data: data, options: options);
      EasyLoading.dismiss();
      return _handleResponse(response);
    } catch (e) {
      EasyLoading.dismiss();
      var exception = ApiException.from(e);
      if (handleException(exception, onError: onError) != true) {
        throw exception;
      }
    }

    return null;
  }

  _convertRequestData(data) {
    if (data != null) {
      data = jsonDecode(jsonEncode(data));
    }
    return data;
  }

  Future<T?> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool showLoading = false,
    Function(Map)? onResponse,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        queryParameters: queryParameters,
        headers: headers,
        showLoading: showLoading,
        onError: onError);
  }

  Future<T?> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool showLoading = false,
    Function(Map)? onResponse,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        method: "POST",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        showLoading: showLoading,
        onError: onError);
  }

  Future<T?> delete<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool showLoading = false,
    Function(Map)? onResponse,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        method: "DELETE",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        showLoading: showLoading,
        onError: onError);
  }

  Future<T?> put<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool showLoading = false,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        method: "PUT",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        showLoading: showLoading,
        onError: onError);
  }

  Future<T?> uploadFile<T>(
    String filePath,
    String url, {
    String method = "POST",
    bool showLoading = false,
    Map<String, dynamic>? headers,
    bool Function(ApiException)? onError,
  }) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      try {
        Options options = Options()
          ..method = method
          ..headers = headers;

        final String name = filePath.substring(filePath.lastIndexOf('/') + 1);
        final FormData formData = FormData.fromMap(<String, dynamic>{
          'file': await MultipartFile.fromFile(filePath, filename: name)
        });
        Response response =
            await _dio.request(url, data: formData, options: options);

          return _handleResponse<T>(response);
      } catch (e) {
        rethrow;
      } finally {
        EasyLoading.dismiss();
      }
    } catch (e) {
      var exception = ApiException.from(e);
      if (handleException(exception, onError: onError) != true) {
        throw exception;
      }

      // if(onError?.call(exception) != true){
      //   throw exception;
      // }
    }
    // finally {
    //   EasyLoading.dismiss();
    // }
    return null;
  }

  Future<bool> downloadFile(
    String urlPath,
    String savePath, {
    Function(int count, int total)? onProgress,
  }) async {
    Response result =
        await _dio.download(urlPath, savePath, onReceiveProgress: onProgress);
    return result.statusCode == 200;
  }

  ///请求响应内容处理
  T? _handleResponse<T>(Response response) {
    if (response.statusCode == 200) {
      return  response.data;
    } else {
      var exception = ApiException(response.statusCode, ApiException.unknownException);
      throw exception;
    }
  }

  ///业务内容处理
  // T? _handleBusinessResponse<T>(ApiResponse<T> response) {
  //   if (response.code == ApiConfig.successCode) {
  //     return response.data;
  //   } else {
  //     var exception = ApiException(response.code, response.message);
  //     throw exception;
  //   }
  // }
}
