import 'package:bookstar_app/pages/LoginPage2.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookstar_app/components/MainScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String backendUrl = 'http://15.164.30.67:8080';
  final String kakaoClientId = 'dabc03ab276a52d80250bdfb974360a3';
  final String redirectUri = 'http://localhost:8080/api/v1/auth/register';

  bool _isLoading = false;

  Future<void> _handleOAuthResponse(String url) async {
    final Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('code')) {
      final String code = uri.queryParameters['code']!;
      await _exchangeCodeForToken(code);
    }
  }

  Future<void> _exchangeCodeForToken(String code) async {
    if (!mounted) return; // Prevent setState if the widget is no longer mounted
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $code'
        },
        body: json.encode({
          "serviceUsingAgree": "Y",
          "personalInformationAgree": "Y",
          "marketingAgree": "N"
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String appAccessToken = responseData['accessToken'];
        showDialog(
            context: context,
            builder: (_) => AlertDialog(title: Text("오아스 통과")));
        // Access token 검증
        await _verifyAccessToken(appAccessToken);
      } else {
        _showErrorDialog('Login failed: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Network error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyAccessToken(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/auth/login/accesstoken'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        print('Verified Access Token: $accessToken');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        _navigateToMainScreen();
      } else {
        _showErrorDialog('Access token validation failed: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Network error during token verification: $e');
    }
  }

  void _navigateToMainScreen() {
    if (!mounted)
      return; // Prevent navigation if the widget is no longer mounted
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage2()),
      // MaterialPageRoute(builder: (_) => MainScreen(selectedIndex: 0)),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted)
      return; // Prevent showing dialog if the widget is no longer mounted
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
  }

  @override
  Widget build(BuildContext context) {
    final authUrl =
        'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=dabc03ab276a52d80250bdfb974360a3&redirect_uri=http://localhost:8080/api/v1/auth/register';

    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(redirectUri)) {
              _handleOAuthResponse(request.url);
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(authUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Kakao Login'),
                          centerTitle: true,
                        ),
                        body: WebViewWidget(controller: webViewController),
                      ),
                    ),
                  );
                },
                child: Text('Kakao 로그인'),
              ),
      ),
    );
  }
}
