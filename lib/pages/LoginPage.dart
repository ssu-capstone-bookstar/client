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
      await _handleKakaoSignIn(code);
    }
  }

  bool _isErrorShown = false;

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
      _sendAuthorizationCodeToServer(authorizationCode, givenName); // 서버로 코드 전송
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
      body: Column(
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
                    appBar:
                        AppBar(title: Text('Kakao Login'), centerTitle: true),
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
    );
  }
}
