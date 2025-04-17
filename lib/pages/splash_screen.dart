import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:bookstar_app/pages/home/home_page.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    autoLogin();

    // Future.delayed(
    //   Duration(seconds: 2),
    //   () {
    //     if (!mounted) return;
    //     context.go(LoginPage.routePath);
    //   },
    // );
  }

  Future<void> autoLogin() async {
    String? accessToken = prefs.getString('accessToken');
    int? memberId = prefs.getInt('memberId');
    String? profileImage = prefs.getString('profileImage');
    String? nickName = prefs.getString('nickName');
    await Future.delayed(
      Duration(seconds: 2),
      () async {
        if (accessToken != null) {
          if (!mounted) return;
          context.read<UserProvider>().setUserInfo(
                userId: memberId,
                nickName: nickName,
                profileImage: profileImage,
                accessToken: accessToken,
              );
          context.go(HomePage.routePath);
        } else {
          await prefs.clear();
          if (!mounted) return;
          context.go(LoginPage.routePath);
        }
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
