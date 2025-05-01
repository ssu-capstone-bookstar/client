import 'package:bookstar_app/bookstar_router.dart';
import 'package:bookstar_app/global/state/Index_cubit/index_cubit.dart';
import 'package:bookstar_app/global/state/login_cubit/login_cubit.dart';
import 'package:bookstar_app/pages/auth/state/social_login_cubit.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 📦 `prefs`
///
/// 앱에서 쓰이는 전역 `SharedPreferences`
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 인스턴스 가져오기
  prefs = await SharedPreferences.getInstance();

  // dotenv 설정
  await dotenv.load();

  // 저장된 사용자 정보 가져오기
  // final userId = prefs.getInt('id');
  // final nickName = prefs.getString('nickName');
  // final profileImage = prefs.getString('profileImage');
  // final accessToken = prefs.getString('accessToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()
            // ..setUserInfo(
            //   userId: userId,
            //   nickName: nickName,
            //   profileImage: profileImage,
            //   accessToken: accessToken,
            // ),
            ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialLoginCubit(),
        ),
        BlocProvider(
          create: (context) => IndexCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Book SNS App',
        theme: ThemeData(
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            // iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black, // 제목 색상 변경
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routerConfig: BookstarRouter.router,
        debugShowCheckedModeBanner: false,
        // home: MainScreen(selectedIndex: 0), // 초기 페이지 설정
        //home: const LoginPage(),
        // home: BookInfo(id: "324"),
        // home: MyFeed(
        //     id: 2,
        //     url:
        //         "https://image.aladin.co.kr/product/29288/76/coversum/k112837109_1.jpg"),
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/home':
        //       return MaterialPageRoute(
        //           builder: (_) => const MainScreen(selectedIndex: 0));
        //     case '/search':
        //       return MaterialPageRoute(
        //           builder: (_) => const MainScreen(selectedIndex: 1));
        //     case '/profile':
        //       return MaterialPageRoute(
        //           builder: (_) => const MainScreen(selectedIndex: 2));
        //     case '/bookinfo':
        //       final int id = settings.arguments as int;
        //       return MaterialPageRoute(builder: (_) => BookInfo(id: id));
        //     case '/newsfeed':
        //       return MaterialPageRoute(builder: (_) => const NewsFeed());
        //     // case '/addrecord':
        //     //   return MaterialPageRoute(builder: (_) => const AddRecord());
        //     case '/scrap':
        //       final int bookId = settings.arguments as int;
        //       return MaterialPageRoute(builder: (_) => Scrap(bookId: bookId));
        //     case '/scrapwhite':
        //       return MaterialPageRoute(builder: (_) => const ScrapWhite());
        //     case '/writereview':
        //       final int bookId = settings.arguments as int;
        //       final String url = settings.arguments as String;
        //       return MaterialPageRoute(
        //           builder: (_) => WriteReview(bookId: bookId, url: url));
        //     case '/mylibrary':
        //       return MaterialPageRoute(builder: (_) => const MyLibrary());
        //     case '/myrecommendations':
        //       return MaterialPageRoute(
        //           builder: (_) => const MyRecommendations());
        //     case '/myscraps':
        //       return MaterialPageRoute(builder: (_) => const MyScraps());
        //     case '/myreviews':
        //       return MaterialPageRoute(builder: (_) => const MyReviews());
        //     // case '/mycompletedbooks':
        //     //   return MaterialPageRoute(
        //     //       builder: (_) => const MyCompletedBooks());
        //     // case '/mycomments':
        //     //   return MaterialPageRoute(builder: (_) => const MyComments());
        //     case '/myfollowings':
        //       return MaterialPageRoute(builder: (_) => const MyFollowings());
        //     case '/myfollowers':
        //       return MaterialPageRoute(builder: (_) => const MyFollowings());
        //     // case '/mybookfeed':
        //     //   final int bookId = settings.arguments as int;
        //     //   return MaterialPageRoute(builder: (_) => MyBookFeed(id: bookId));
        //     case '/profilesettings':
        //       return MaterialPageRoute(builder: (_) => const ProfileSettings());
        //     // case '/loginpage2':
        //     //   return MaterialPageRoute(builder: (_) => const LoginPage2());
        //     case '/elseprofille':
        //       final int memberId = settings.arguments as int;
        //       return MaterialPageRoute(
        //           builder: (_) => ElseProfilePage(memberId: memberId));
        //     case '/myfeed':
        //       final int id = settings.arguments as int;
        //       final String url = settings.arguments as String;
        //       return MaterialPageRoute(
        //           builder: (_) => MyFeed(
        //                 id: id,
        //                 url: url,
        //               ));
        //     default:
        //       return MaterialPageRoute(
        //           builder: (_) => const MainScreen(selectedIndex: 0));
        //   }
        // },
      ),
    );
  }
}
