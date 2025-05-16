import 'package:bookstar_app/global/state/login_cubit/login_cubit.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
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
    final cubit = context.read<LoginCubit>();
    String? accessToken = await secureStorage.read(key: 'accessToken');
    //String? accessToken = prefs.getString('accessToken');
    int? memberId = prefs.getInt('memberId');
    String? profileImage = prefs.getString('profileImage');
    String? nickName = prefs.getString('nickName');
    String? provider = prefs.getString('provider');
    String? idToken = prefs.getString('idToken');
    await Future.delayed(
      Duration(milliseconds: 500),
      () async {
        if (provider != null) {
          if (!mounted) return;
          await cubit.handleAppLogin(
            idToken: idToken,
            provider: provider,
          );
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
        child: Hero(
          tag: 'Logo',
          child: Image.asset(
            'assets/images/App_LOGO.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
