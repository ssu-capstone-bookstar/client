import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  String? _nickName;
  String? _profileImage;
  String? _accessToken;

  // Getters
  int? get userId => _userId;
  String? get nickName => _nickName;
  String? get profileImage => _profileImage;
  String? get accessToken => _accessToken;

  // 사용자 정보 설정
  void setUserInfo({
    int? userId,
    String? nickName,
    String? profileImage,
    String? accessToken,
  }) {
    _userId = userId;
    _nickName = nickName;
    _profileImage = profileImage;
    _accessToken = accessToken;
    notifyListeners();
  }

  // 로그아웃 시 정보 초기화
  void clearUserInfo() {
    _userId = null;
    _nickName = null;
    _profileImage = null;
    _accessToken = null;
    notifyListeners();
  }

  // 토큰 유효성 확인
  bool get isLoggedIn => _accessToken != null;
}
