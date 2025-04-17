import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';
  static const String routePath = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    //TODO:여기서 자동로그인 설정 및 서버에서 토큰받아오기
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (!mounted) return;
        context.go(LoginPage.routePath);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/App_LOGO.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
