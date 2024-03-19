class Detail {
  Detail({
      int? code,
      dynamic msg,
      List<Data>? data,
      bool? success,
      int? total,}){
    _code = code;
    _msg = msg;
    _data = data;
    _success = success;
    _total = total;
}

  Detail.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _success = json['success'];
    _total = json['total'];
  }
  int? _code;
  dynamic _msg;
  List<Data>? _data;
  bool? _success;
  int? _total;

  int? get code => _code;
  dynamic get msg => _msg;
  List<Data>? get data => _data;
  bool? get success => _success;
  int? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['total'] = _total;
    return map;
  }

}

class Data {
  Data({
      String? createTime, 
      String? updateTime, 
      dynamic remark, 
      dynamic params, 
      int? id, 
      String? avatar, 
      dynamic avatarFrame, 
      String? username, 
      String? account, 
      String? password, 
      String? phone, 
      dynamic parentUserId, 
      String? nickname, 
      int? sex, 
      double? balance, 
      double? totalProfit, 
      String? tagIds, 
      int? isAuthIdentity, 
      bool? isOpenPhoto, 
      int? isStudent, 
      dynamic sysCircleId, 
      dynamic circleIds, 
      int? enabled, 
      String? birthday, 
      int? isDel, 
      int? isRobot, 
      int? memberType, 
      dynamic makeMemberTime, 
      String? wxUnionId, 
      dynamic appleId, 
      dynamic schoolName, 
      String? intro, 
      int? isBeautifulId, 
      dynamic about, 
      dynamic voice, 
      dynamic voiceImg, 
      String? address, 
      String? province, 
      String? district, 
      dynamic associationId, 
      int? isOpenRecommend, 
      int? foodStallBalance, 
      dynamic circleLevel, 
      String? inviteCode, 
      dynamic disabledTime,}){
    _createTime = createTime;
    _updateTime = updateTime;
    _remark = remark;
    _params = params;
    _id = id;
    _avatar = avatar;
    _avatarFrame = avatarFrame;
    _username = username;
    _account = account;
    _password = password;
    _phone = phone;
    _parentUserId = parentUserId;
    _nickname = nickname;
    _sex = sex;
    _balance = balance;
    _totalProfit = totalProfit;
    _tagIds = tagIds;
    _isAuthIdentity = isAuthIdentity;
    _isOpenPhoto = isOpenPhoto;
    _isStudent = isStudent;
    _sysCircleId = sysCircleId;
    _circleIds = circleIds;
    _enabled = enabled;
    _birthday = birthday;
    _isDel = isDel;
    _isRobot = isRobot;
    _memberType = memberType;
    _makeMemberTime = makeMemberTime;
    _wxUnionId = wxUnionId;
    _appleId = appleId;
    _schoolName = schoolName;
    _intro = intro;
    _isBeautifulId = isBeautifulId;
    _about = about;
    _voice = voice;
    _voiceImg = voiceImg;
    _address = address;
    _province = province;
    _district = district;
    _associationId = associationId;
    _isOpenRecommend = isOpenRecommend;
    _foodStallBalance = foodStallBalance;
    _circleLevel = circleLevel;
    _inviteCode = inviteCode;
    _disabledTime = disabledTime;
}

  Data.fromJson(dynamic json) {
    _createTime = json['createTime'];
    _updateTime = json['updateTime'];
    _remark = json['remark'];
    _params = json['params'];
    _id = json['id'];
    _avatar = json['avatar'];
    _avatarFrame = json['avatarFrame'];
    _username = json['username'];
    _account = json['account'];
    _password = json['password'];
    _phone = json['phone'];
    _parentUserId = json['parentUserId'];
    _nickname = json['nickname'];
    _sex = json['sex'];
    _balance = json['balance'];
    _totalProfit = json['totalProfit'];
    _tagIds = json['tagIds'];
    _isAuthIdentity = json['isAuthIdentity'];
    _isOpenPhoto = json['isOpenPhoto'];
    _isStudent = json['isStudent'];
    _sysCircleId = json['sysCircleId'];
    _circleIds = json['circleIds'];
    _enabled = json['enabled'];
    _birthday = json['birthday'];
    _isDel = json['isDel'];
    _isRobot = json['isRobot'];
    _memberType = json['memberType'];
    _makeMemberTime = json['makeMemberTime'];
    _wxUnionId = json['wxUnionId'];
    _appleId = json['appleId'];
    _schoolName = json['schoolName'];
    _intro = json['intro'];
    _isBeautifulId = json['isBeautifulId'];
    _about = json['about'];
    _voice = json['voice'];
    _voiceImg = json['voiceImg'];
    _address = json['address'];
    _province = json['province'];
    _district = json['district'];
    _associationId = json['associationId'];
    _isOpenRecommend = json['isOpenRecommend'];
    _foodStallBalance = json['foodStallBalance'];
    _circleLevel = json['circleLevel'];
    _inviteCode = json['inviteCode'];
    _disabledTime = json['disabledTime'];
  }
  String? _createTime;
  String? _updateTime;
  dynamic _remark;
  dynamic _params;
  int? _id;
  String? _avatar;
  dynamic _avatarFrame;
  String? _username;
  String? _account;
  String? _password;
  String? _phone;
  dynamic _parentUserId;
  String? _nickname;
  int? _sex;
  double? _balance;
  double? _totalProfit;
  String? _tagIds;
  int? _isAuthIdentity;
  bool? _isOpenPhoto;
  int? _isStudent;
  dynamic _sysCircleId;
  dynamic _circleIds;
  int? _enabled;
  String? _birthday;
  int? _isDel;
  int? _isRobot;
  int? _memberType;
  dynamic _makeMemberTime;
  String? _wxUnionId;
  dynamic _appleId;
  dynamic _schoolName;
  String? _intro;
  int? _isBeautifulId;
  dynamic _about;
  dynamic _voice;
  dynamic _voiceImg;
  String? _address;
  String? _province;
  String? _district;
  dynamic _associationId;
  int? _isOpenRecommend;
  int? _foodStallBalance;
  dynamic _circleLevel;
  String? _inviteCode;
  dynamic _disabledTime;

  String? get createTime => _createTime;
  String? get updateTime => _updateTime;
  dynamic get remark => _remark;
  dynamic get params => _params;
  int? get id => _id;
  String? get avatar => _avatar;
  dynamic get avatarFrame => _avatarFrame;
  String? get username => _username;
  String? get account => _account;
  String? get password => _password;
  String? get phone => _phone;
  dynamic get parentUserId => _parentUserId;
  String? get nickname => _nickname;
  int? get sex => _sex;
  double? get balance => _balance;
  double? get totalProfit => _totalProfit;
  String? get tagIds => _tagIds;
  int? get isAuthIdentity => _isAuthIdentity;
  bool? get isOpenPhoto => _isOpenPhoto;
  int? get isStudent => _isStudent;
  dynamic get sysCircleId => _sysCircleId;
  dynamic get circleIds => _circleIds;
  int? get enabled => _enabled;
  String? get birthday => _birthday;
  int? get isDel => _isDel;
  int? get isRobot => _isRobot;
  int? get memberType => _memberType;
  dynamic get makeMemberTime => _makeMemberTime;
  String? get wxUnionId => _wxUnionId;
  dynamic get appleId => _appleId;
  dynamic get schoolName => _schoolName;
  String? get intro => _intro;
  int? get isBeautifulId => _isBeautifulId;
  dynamic get about => _about;
  dynamic get voice => _voice;
  dynamic get voiceImg => _voiceImg;
  String? get address => _address;
  String? get province => _province;
  String? get district => _district;
  dynamic get associationId => _associationId;
  int? get isOpenRecommend => _isOpenRecommend;
  int? get foodStallBalance => _foodStallBalance;
  dynamic get circleLevel => _circleLevel;
  String? get inviteCode => _inviteCode;
  dynamic get disabledTime => _disabledTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createTime'] = _createTime;
    map['updateTime'] = _updateTime;
    map['remark'] = _remark;
    map['params'] = _params;
    map['id'] = _id;
    map['avatar'] = _avatar;
    map['avatarFrame'] = _avatarFrame;
    map['username'] = _username;
    map['account'] = _account;
    map['password'] = _password;
    map['phone'] = _phone;
    map['parentUserId'] = _parentUserId;
    map['nickname'] = _nickname;
    map['sex'] = _sex;
    map['balance'] = _balance;
    map['totalProfit'] = _totalProfit;
    map['tagIds'] = _tagIds;
    map['isAuthIdentity'] = _isAuthIdentity;
    map['isOpenPhoto'] = _isOpenPhoto;
    map['isStudent'] = _isStudent;
    map['sysCircleId'] = _sysCircleId;
    map['circleIds'] = _circleIds;
    map['enabled'] = _enabled;
    map['birthday'] = _birthday;
    map['isDel'] = _isDel;
    map['isRobot'] = _isRobot;
    map['memberType'] = _memberType;
    map['makeMemberTime'] = _makeMemberTime;
    map['wxUnionId'] = _wxUnionId;
    map['appleId'] = _appleId;
    map['schoolName'] = _schoolName;
    map['intro'] = _intro;
    map['isBeautifulId'] = _isBeautifulId;
    map['about'] = _about;
    map['voice'] = _voice;
    map['voiceImg'] = _voiceImg;
    map['address'] = _address;
    map['province'] = _province;
    map['district'] = _district;
    map['associationId'] = _associationId;
    map['isOpenRecommend'] = _isOpenRecommend;
    map['foodStallBalance'] = _foodStallBalance;
    map['circleLevel'] = _circleLevel;
    map['inviteCode'] = _inviteCode;
    map['disabledTime'] = _disabledTime;
    return map;
  }

}