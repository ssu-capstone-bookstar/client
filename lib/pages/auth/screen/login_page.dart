import 'package:bookstar_app/constants/tems_and_policy.dart';
import 'package:bookstar_app/global/state/login_cubit/login_cubit.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/auth/state/social_login_cubit.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login';
  static const String routePath = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    // 카카오 SDK 초기화
    final String? kakaoAppKey = dotenv.env['KAKAO_NATIVE_KEY'];
    if (kakaoAppKey != null && kakaoAppKey.isNotEmpty) {
      KakaoSdk.init(nativeAppKey: kakaoAppKey);
    } else {
      debugPrint('카카오 init에러');
    }
  }

  // 개인정보 처리방침 동의 팝업
  Future<void> _showPrivacyPolicyDialog() async {
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
                      context.go(HomePage.routePath);
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

  @override
  Widget build(BuildContext context) {
    final SocialLoginCubit socialLoginCubit = context.read<SocialLoginCubit>();
    final LoginCubit loginCubit = context.read<LoginCubit>();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 280),
              Hero(
                tag: 'Logo',
                child: Image.asset(
                  'assets/images/App_LOGO.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
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
                onTap: () async {
                  await socialLoginCubit.handleKakaoLogin();

                  String idToken = prefs.getString('idToken') ?? '';
                  String provider = prefs.getString('provider') ?? '';

                  await loginCubit.handleAppLogin(
                    idToken: idToken,
                    provider: provider,
                  );

                  String? accessToken =
                      await secureStorage.read(key: 'accessToken');

                  //String? accessToken = prefs.getString('accessToken');
                  int? memberId = prefs.getInt('memberId');
                  String? profileImage = prefs.getString('profileImage');
                  String? nickName = prefs.getString('nickName');

                  if (!context.mounted) return;

                  context.read<UserProvider>().setUserInfo(
                        userId: memberId,
                        nickName: nickName,
                        profileImage: profileImage,
                        accessToken: accessToken,
                      );

                  _showPrivacyPolicyDialog();
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
                  await socialLoginCubit.handleAppleSignIn();

                  String idToken = prefs.getString('idToken') ?? '';
                  String provider = prefs.getString('provider') ?? '';

                  await loginCubit.handleAppLogin(
                    idToken: idToken,
                    provider: provider,
                  );

                  String? accessToken =
                      await secureStorage.read(key: 'accessToken');
                  //String? accessToken = prefs.getString('accessToken');
                  int? memberId = prefs.getInt('memberId');
                  String? profileImage = prefs.getString('profileImage');
                  String? nickName = prefs.getString('nickName');

                  if (!context.mounted) return;

                  context.read<UserProvider>().setUserInfo(
                        userId: memberId,
                        nickName: nickName,
                        profileImage: profileImage,
                        accessToken: accessToken,
                      );

                  _showPrivacyPolicyDialog();
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
        ],
      ),
    );
  }
}
