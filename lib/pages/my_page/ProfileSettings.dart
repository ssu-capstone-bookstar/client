import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileSettings extends StatelessWidget {
  final String backendUrl = 'http://15.164.30.67:8080';

  const ProfileSettings({super.key});

  Future<bool> _withdrawAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    try {
      final response = await http.delete(
        Uri.parse("$backendUrl/api/v1/auth/withdraw"),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // 응답 코드 및 본문 출력
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      print("Error occurred: $e");
      print("StackTrace: $stackTrace"); // 오류 발생 시 스택 트레이스도 출력

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('네트워크 오류: $e')),
        );
      }
      return false;
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('id');
    await prefs.remove('nickName');
    await prefs.remove('profileImage');

    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    if (context.mounted) {
      // context가 아직 유효한지 확인
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  void _showWithdrawConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말 탈퇴하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // 다이얼로그 닫기

              // 로딩 표시
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              }

              final success = await _withdrawAccount(context);

              if (context.mounted) {
                Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

                if (success) {
                  await _logout(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('탈퇴에 실패했습니다.')),
                  );
                }
              }
            },
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _logout(context);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.black)),
            onTap: () => _showLogoutConfirmDialog(context),
          ),
          const Divider(),
          ListTile(
            title: const Text('회원 탈퇴', style: TextStyle(color: Colors.red)),
            onTap: () => _showWithdrawConfirmDialog(context),
          ),
        ],
      ),
    );
  }
}
