
import 'dart:convert';

class ApiResponse<T> {
  int? code;
  String? message;
  T? data;

  ApiResponse({this.code, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'] as T,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
