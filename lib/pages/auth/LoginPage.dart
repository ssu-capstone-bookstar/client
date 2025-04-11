import 'dart:convert';

import 'package:bookstar_app/components/MainScreen.dart';
import 'package:bookstar_app/constants/tems_and_policy.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String backendUrl = 'http://15.164.30.67:8080';
  final String kakaoClientId = 'dabc03ab276a52d80250bdfb974360a3';
  final String redirectUri = 'http://localhost:8080/api/v1/auth/register';
  bool _isLoading = false;
  bool _isOAuthHandled = false; // 중복 방지를 위한 변수 추가
  bool _isAppleSignInInProgress = false;

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
          title: const Text('개인정보 처리방침 동의',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 전체 동의 체크박스
                CheckboxListTile(
                  title: const Text('전체 동의',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  value: isAllAgreed,
                  onChanged: (value) {
                    setState(() {
                      isAllAgreed = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(),
                // 개인정보 처리방침 텍스트
                const Text('개인정보 처리 방침',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const SingleChildScrollView(
                    child: Text(
                      Constants.privacyPolicy,
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
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: isAllAgreed
                  ? () {
                      Navigator.of(context).pop();
                      onAccept();
                    }
                  : null,
              style: TextButton.styleFrom(
                foregroundColor:
                    isAllAgreed ? Theme.of(context).primaryColor : Colors.grey,
              ), // 전체 동의하지 않으면 비활성화
              child: const Text('동의'),
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
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen(selectedIndex: 1)),
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
    if (_isAppleSignInInProgress) return;
    try {
      _isAppleSignInInProgress = true;
      setState(() => _isLoading = true);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String authorizationCode = credential.authorizationCode;
      final String? givenName = credential.givenName;
      print("Apple Authorization Code: $authorizationCode");
      print("Apple Authorization givenName: $givenName");

      // 약관 동의 팝업 표시 후 애플 로그인 처리
      _showPrivacyPolicyDialog(
          onAccept: () =>
              _sendAuthorizationCodeToServer(authorizationCode, givenName),
          provider: "apple");
    } catch (error) {
      if (!_isErrorShown) {
        _isErrorShown = true;
        _showErrorDialog("Sign in with Apple failed: $error");
      }
    } finally {
      _isAppleSignInInProgress = false;
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen(selectedIndex: 1)),
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
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
              const SizedBox(height: 280),
              Image.asset(
                'assets/images/App_LOGO.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/App_Text_LOGO.png',
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                            title: const Text('Kakao Login'),
                            centerTitle: true),
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
              const SizedBox(height: 10),
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
                  child: const Center(
                    child: Text(
                      'Apple 로그인',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
