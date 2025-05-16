import 'package:bookstar_app/global/state/Index_cubit/index_cubit.dart';
import 'package:bookstar_app/global/state/auth_cubit/auth_cubit.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await prefs.clear();
    await secureStorage.deleteAll();

    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    if (context.mounted) {
      context.read<IndexCubit>().setIndex(index: 1);
      context.go(SplashScreen.routePath);
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

              final bool success =
                  await context.read<AuthCubit>().handleAppWithdraw();

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
