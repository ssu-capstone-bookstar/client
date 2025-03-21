import 'dart:convert';
import 'package:bookstar_app/components/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String backendUrl = 'http://15.164.30.67:8080';
  final String kakaoClientId = 'dabc03ab276a52d80250bdfb974360a3';
  final String redirectUri = 'http://localhost:8080/api/v1/auth/register';
  bool _isLoading = false;
  bool _isOAuthHandled = false; // 중복 방지를 위한 변수 추가

  Future<void> _handleOAuthResponse(String url) async {
    if (_isOAuthHandled) return; // 이미 처리된 경우 다시 실행하지 않음

    final Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('code')) {
      _isOAuthHandled = true; // 한 번 실행되면 true로 설정하여 중복 호출 방지
      final String code = uri.queryParameters['code']!;
      print('인가 코드 : $code');

      // 약관 동의 팝업 표시 후 로그인 처리
      _showPrivacyPolicyDialog(
          onAccept: () => _handleKakaoSignIn(code), provider: "kakao");
    }
  }

  bool _isErrorShown = false;

  // 개인정보 처리방침 동의 팝업
  Future<void> _showPrivacyPolicyDialog(
      {required Function onAccept, required String provider}) async {
    if (!mounted) return;

    bool isAllAgreed = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text('개인정보 처리방침 동의',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 전체 동의 체크박스
                CheckboxListTile(
                  title: Text('전체 동의',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  value: isAllAgreed,
                  onChanged: (value) {
                    setState(() {
                      isAllAgreed = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Divider(),
                // 개인정보 처리방침 텍스트
                Text('개인정보 처리 방침',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(
                      '''개인정보 처리 방침
최종 업데이트: 2024년 2월 15일

본 개인정보 처리 방침은 북스타(BookStar) 애플리케이션(이하 "앱")에서 수집하는 개인정보의 종류, 이용 목적, 보관 기간, 공유 여부 및 사용자의 권리를 명시합니다. 북스타를 이용하는 사용자는 본 방침을 읽고 이에 동의하는 것으로 간주됩니다.

1. 수집하는 개인정보 항목 및 수집 방법
북스타는 원활한 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.
(1) 필수적으로 수집되는 정보
- 회원 가입 및 계정 관리: 이메일 주소, 사용자 이름(닉네임), 비밀번호
- 서비스 이용 기록: 읽은 책 목록, 리뷰 및 평가 기록, 스크랩한 문장, 북 캘린더 데이터
- 소셜 기능 관련 정보: 팔로우 및 친구 목록, 댓글 내역, 추천 책 기록
- 기기 정보: 기기 모델, 운영 체제, IP 주소(로그인 및 보안 목적)
(2) 선택적으로 제공 가능한 정보
- 프로필 설정: 프로필 사진

2. 개인정보 수집 및 이용 목적
북스타는 다음과 같은 목적으로 개인정보를 수집 및 이용합니다.
- 회원 관리: 계정 생성, 로그인, 사용자 인증
- 서비스 제공: 독서 기록 저장, 리뷰 및 스크랩 기능 제공, 개인화된 추천 시스템 운영
- 커뮤니티 기능: 팔로우, 댓글, 추천 책 공유 기능 제공
- 보안 및 운영 관리: 사용자 계정 보호, 불법 사용 방지, 시스템 안정성 유지
- 서비스 개선: 앱 사용 패턴 분석, 오류 개선 및 기능 최적화

3. 개인정보 보관 기간 및 삭제
북스타는 사용자의 개인정보를 서비스 제공 기간 동안 보관하며, 사용자가 계정을 삭제하면 아래와 같이 처리됩니다.
- 회원 탈퇴 시: 개인 데이터(이메일 주소, 사용자 이름, 비밀번호) 즉시 삭제

4. 개인정보 제3자 제공 및 공유
북스타는 사용자의 개인정보를 원칙적으로 제3자에게 제공하지 않습니다. 다만, 아래의 경우 예외적으로 제공될 수 있습니다.
- 법적 요구가 있는 경우: 수사 기관의 요청에 따라 법률에 의해 요구될 경우
- 서비스 운영을 위한 외부 서비스 이용: 북스타는 앱 운영을 위해 Google Firebase, AWS 등 클라우드 서비스 제공업체를 이용하며, 이 과정에서 최소한의 정보가 저장될 수 있습니다.

5. 사용자의 권리 및 설정 옵션
사용자는 개인정보 보호 관련하여 다음과 같은 권리를 가집니다.
- 개인정보 열람, 수정, 삭제 요청 가능
- 프로필 설정에서 일부 정보 변경 가능
- 계정 삭제 요청 시, 모든 개인정보가 삭제됨
문의 사항이나 개인정보 관련 요청은 앱 내 고객지원 또는 이메일(withjune28@gmail.com)로 접수할 수 있습니다.

6. 개인정보 보호를 위한 보안 조치
북스타는 사용자의 개인정보를 안전하게 보호하기 위해 다음과 같은 보안 조치를 적용합니다.
- 데이터 암호화: 비밀번호는 암호화 저장, HTTPS 프로토콜을 통한 데이터 전송
- 접근 제한: 개인정보 접근을 최소한으로 제한

7. 부적절한 콘텐츠 및 사용자에 대한 무관용 정책
북스타는 건강한 커뮤니티 환경을 유지하기 위해 다음과 같은 무관용 정책을 시행합니다.

금지되는 행위:

욕설, 혐오 표현, 차별, 성희롱, 폭력적 또는 선정적인 콘텐츠 게시 타인의 개인정보 도용 또는 사칭 스팸성 콘텐츠 및 광고 목적의 활동 지적재산권 침해 행위 조치 사항:

위반 시, 사전 경고 없이 해당 콘텐츠 삭제 및 계정 정지 또는 영구 이용 제한 조치가 취해질 수 있습니다. 반복 위반자에 대해서는 관련 법령에 따라 신고 조치가 이뤄질 수 있습니다. 신고 기능:

사용자는 앱 내 신고 기능을 통해 부적절한 콘텐츠나 사용자를 신고할 수 있으며, 운영팀은 즉시 확인 후 24시간 안에 조치를 취합니다.

8. 개인정보 처리 방침 변경
본 개인정보 처리 방침은 서비스 변경, 법률 개정 등에 따라 업데이트될 수 있으며, 변경 사항은 앱 내 공지를 통해 안내됩니다.
본 방침에 대한 문의 사항이 있을 경우, 이메일 (withjune28@gmail.com)으로 연락해 주세요.''',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: isAllAgreed
                  ? () {
                      Navigator.of(context).pop();
                      onAccept();
                    }
                  : null, // 전체 동의하지 않으면 비활성화
              child: Text('동의'),
              style: TextButton.styleFrom(
                foregroundColor:
                    isAllAgreed ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _handleKakaoSignIn(String code) async {
    if (!mounted) return;

    print(code);
    try {
      setState(() => _isLoading = true);

      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'}, // 헤더 추가
        body: json.encode({"code": code, "providerName": "kakao"}),
      );

      final utf8Body = utf8.decode(response.bodyBytes);
      final tokenData = json.decode(utf8Body);
      if (response.statusCode == 200) {
        final accessToken = tokenData['data']['accessToken'];
        final memberId = tokenData['data']['memberId'];
        final nickName = tokenData['data']['nickName'];
        final profileImage = tokenData['data']['profileImage'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('memberId', memberId);
        prefs.setString('nickName', nickName ?? "noname");
        prefs.setString('profileImage', profileImage ?? "");
        prefs.setString('accessToken', accessToken);
        print('Stored User Information:');
        print('memberId: $memberId');
        print('nickName: $nickName');
        print('profileImage: $profileImage');
        print('accessToken: $accessToken');
        if (mounted) {
          context.read<UserProvider>().setUserInfo(
                userId: memberId,
                nickName: nickName,
                profileImage: profileImage,
                accessToken: accessToken,
              );
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen(selectedIndex: 1)),
        );
      } else {
        if (!_isErrorShown) {
          _isErrorShown = true;
          _showErrorDialog('Login failed: ${response.body}');
        }
      }
    } catch (e) {
      if (!_isErrorShown) {
        _isErrorShown = true;
        _showErrorDialog('Network error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String? authorizationCode = credential.authorizationCode;
      final String? givenName = credential.givenName;
      print("Apple Authorization Code: $authorizationCode");
      print("Apple Authorization givenName: $givenName");

      // 약관 동의 팝업 표시 후 애플 로그인 처리
      _showPrivacyPolicyDialog(
          onAccept: () =>
              _sendAuthorizationCodeToServer(authorizationCode, givenName),
          provider: "apple");
    } catch (error) {
      _showErrorDialog("Sign in with Apple failed: $error");
    }
  }

  Future<void> _sendAuthorizationCodeToServer(
      String? authorizationCode, String? givenName) async {
    final response = await http.post(
      Uri.parse("$backendUrl/api/v1/auth/apple"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "authorizationCode": authorizationCode, // 애플 인가 코드 전송
        "name": givenName,
      }),
    );
    if (response.statusCode == 200) {
      print("Successfully authenticated with Apple!");
      try {
        final utf8Body = utf8.decode(response.bodyBytes);
        print('Decoded UTF-8 body: $utf8Body');
        final tokenData = json.decode(utf8Body);
        print('response: $tokenData');
        final accessToken = tokenData['data']['accessToken'];
        final memberId = tokenData['data']['memberId'];
        final nickName = tokenData['data']['nickName'];
        final profileImage = tokenData['data']['profileImage'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('memberId', memberId);
        prefs.setString('nickName', nickName ?? "noname");
        prefs.setString('profileImage', profileImage ?? "");
        prefs.setString('accessToken', accessToken);
        print('Stored User Information:');
        print('memberId: $memberId');
        print('nickName: $nickName');
        print('profileImage: $profileImage');
        print('accessToken: $accessToken');
        if (mounted) {
          context.read<UserProvider>().setUserInfo(
                userId: memberId,
                nickName: nickName,
                profileImage: profileImage,
                accessToken: accessToken,
              );
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen(selectedIndex: 1)),
        );
      } catch (e) {
        print('Error decoding response: $e');
      }
    } else {
      print("Failed to authenticate: ${response.body}");
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUrl =
        'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=$kakaoClientId&redirect_uri=$redirectUri';

    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(redirectUri)) {
              _handleOAuthResponse(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..clearCache()
      ..loadRequest(Uri.parse(authUrl));

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 280),
              Image.asset(
                'assets/images/App_LOGO.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/App_Text_LOGO.png',
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                            title: Text('Kakao Login'), centerTitle: true),
                        body: WebViewWidget(controller: webViewController),
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/Kakao.png',
                  width: 500,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await _handleAppleSignIn();
                },
                child: Container(
                  width: 340,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      'Apple 로그인',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
