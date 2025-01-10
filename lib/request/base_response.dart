class BaseResponse<T> {
  int? code;
  String? msg;
  T? data;

  BaseResponse({this.code, this.msg, this.data});

  BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT, // 解析泛型的方法
      ) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? fromJsonT(json['data']) : null;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T? data) toJsonT) {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = toJsonT(data);
    }
    return map;
  }
}