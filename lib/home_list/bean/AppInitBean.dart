class AppInitBean {
  AppInitBean({
      String? key, 
      String? value, 
      String? name,}){
    _key = key;
    _value = value;
    _name = name;
}

  AppInitBean.fromJson(dynamic json) {
    _key = json['key'];
    _value = json['value'];
    _name = json['name'];
  }
  String? _key;
  String? _value;
  String? _name;

  String? get key => _key;
  String? get value => _value;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = _key;
    map['value'] = _value;
    map['name'] = _name;
    return map;
  }

}