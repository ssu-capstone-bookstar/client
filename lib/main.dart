import 'package:bookstar_app/components/MainScreen.dart';
import 'package:bookstar_app/pages/auth/LoginPage.dart';
import 'package:bookstar_app/pages/auth/LoginPage2.dart';
import 'package:bookstar_app/pages/my_page/AddRecord.dart';
import 'package:bookstar_app/pages/my_page/ElseProfilePage.dart';
import 'package:bookstar_app/pages/my_page/MyBookFeed.dart';
import 'package:bookstar_app/pages/my_page/MyComments.dart';
import 'package:bookstar_app/pages/my_page/MyCompletedBooks.dart';
import 'package:bookstar_app/pages/my_page/MyFeed.dart';
import 'package:bookstar_app/pages/my_page/MyFollowings.dart';
import 'package:bookstar_app/pages/my_page/MyRecommendations.dart';
import 'package:bookstar_app/pages/my_page/MyScraps.dart';
import 'package:bookstar_app/pages/my_page/NewsFeed.dart';
import 'package:bookstar_app/pages/my_page/ProfileSettings.dart';
import 'package:bookstar_app/pages/search/BookInfo.dart';
import 'package:bookstar_app/pages/search/MyLibrary.dart';
import 'package:bookstar_app/pages/search/MyReviews.dart';
import 'package:bookstar_app/pages/search/Scrap.dart';
import 'package:bookstar_app/pages/search/ScrapWhite.dart';
import 'package:bookstar_app/pages/search/WriteReview.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 인스턴스 가져오기
  final prefs = await SharedPreferences.getInstance();

  // 저장된 사용자 정보 가져오기
  final userId = prefs.getInt('id');
  final nickName = prefs.getString('nickName');
  final profileImage = prefs.getString('profileImage');
  final accessToken = prefs.getString('accessToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider()
            ..setUserInfo(
              userId: userId,
              nickName: nickName,
              profileImage: profileImage,
              accessToken: accessToken,
            ),
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
    return MaterialApp(
      title: 'Book SNS App',
      theme: ThemeData(
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
      // home: MainScreen(selectedIndex: 0), // 초기 페이지 설정
      home: const LoginPage(),
      // home: BookInfo(id: "324"),
      // home: MyFeed(
      //     id: 2,
      //     url:
      //         "https://image.aladin.co.kr/product/29288/76/coversum/k112837109_1.jpg"),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
                builder: (_) => const MainScreen(selectedIndex: 0));
          case '/search':
            return MaterialPageRoute(
                builder: (_) => const MainScreen(selectedIndex: 1));
          case '/profile':
            return MaterialPageRoute(
                builder: (_) => const MainScreen(selectedIndex: 2));
          case '/bookinfo':
            final int id = settings.arguments as int;
            return MaterialPageRoute(builder: (_) => BookInfo(id: id));
          case '/newsfeed':
            return MaterialPageRoute(builder: (_) => const NewsFeed());
          case '/addrecord':
            return MaterialPageRoute(builder: (_) => const AddRecord());
          case '/scrap':
            final int bookId = settings.arguments as int;
            return MaterialPageRoute(builder: (_) => Scrap(bookId: bookId));
          case '/scrapwhite':
            return MaterialPageRoute(builder: (_) => const ScrapWhite());
          case '/writereview':
            final int bookId = settings.arguments as int;
            final String url = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => WriteReview(bookId: bookId, url: url));
          case '/mylibrary':
            return MaterialPageRoute(builder: (_) => const MyLibrary());
          case '/myrecommendations':
            return MaterialPageRoute(builder: (_) => const MyRecommendations());
          case '/myscraps':
            return MaterialPageRoute(builder: (_) => const MyScraps());
          case '/myreviews':
            return MaterialPageRoute(builder: (_) => const MyReviews());
          case '/mycompletedbooks':
            return MaterialPageRoute(builder: (_) => const MyCompletedBooks());
          case '/mycomments':
            return MaterialPageRoute(builder: (_) => const MyComments());
          case '/myfollowings':
            return MaterialPageRoute(builder: (_) => const MyFollowings());
          case '/myfollowers':
            return MaterialPageRoute(builder: (_) => const MyFollowings());
          case '/mybookfeed':
            final int bookId = settings.arguments as int;
            return MaterialPageRoute(builder: (_) => MyBookFeed(id: bookId));
          case '/profilesettings':
            return MaterialPageRoute(builder: (_) => const ProfileSettings());
          case '/loginpage2':
            return MaterialPageRoute(builder: (_) => const LoginPage2());
          case '/elseprofille':
            final int memberId = settings.arguments as int;
            return MaterialPageRoute(
                builder: (_) => ElseProfilePage(memberId: memberId));
          case '/myfeed':
            final int id = settings.arguments as int;
            final String url = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => MyFeed(
                      id: id,
                      url: url,
                    ));
          default:
            return MaterialPageRoute(
                builder: (_) => const MainScreen(selectedIndex: 0));
        }
      },
    );
  }
}
