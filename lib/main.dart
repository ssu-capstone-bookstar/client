import 'package:bookstar_app/components/MainScreen.dart';
import 'package:bookstar_app/pages/AddRecord.dart';
import 'package:bookstar_app/pages/BookInfo.dart';
import 'package:bookstar_app/pages/ElseProfilePage.dart';
import 'package:bookstar_app/pages/HomePage.dart';
import 'package:bookstar_app/pages/LoginPage.dart';
import 'package:bookstar_app/pages/LoginPage2.dart';
import 'package:bookstar_app/pages/MyBookFeed.dart';
import 'package:bookstar_app/pages/MyComments.dart';
import 'package:bookstar_app/pages/MyCompletedBooks.dart';
import 'package:bookstar_app/pages/MyFeed.dart';
import 'package:bookstar_app/pages/MyFollowings.dart';
import 'package:bookstar_app/pages/MyLibrary.dart';
import 'package:bookstar_app/pages/MyRecommendations.dart';
import 'package:bookstar_app/pages/MyReviews.dart';
import 'package:bookstar_app/pages/MyScraps.dart';
import 'package:bookstar_app/pages/NewsFeed.dart';
import 'package:bookstar_app/pages/ProfilePage.dart';
import 'package:bookstar_app/pages/ProfileSettings.dart';
import 'package:bookstar_app/pages/Scrap.dart';
import 'package:bookstar_app/pages/ScrapWhite.dart';
import 'package:bookstar_app/pages/SearchPage.dart';
import 'package:bookstar_app/pages/WriteReview.dart';
import 'package:bookstar_app/components/MainScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // KakaoSdk.init(nativeAppKey: 'dabc03ab276a52d80250bdfb974360a3');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book SNS App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
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
      home: LoginPage(),
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
                builder: (_) => MainScreen(selectedIndex: 0));
          case '/search':
            return MaterialPageRoute(
                builder: (_) => MainScreen(selectedIndex: 1));
          case '/profile':
            return MaterialPageRoute(
                builder: (_) => MainScreen(selectedIndex: 2));
          case '/bookinfo':
            final String id = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => BookInfo(id: id));
          case '/newsfeed':
            return MaterialPageRoute(builder: (_) => NewsFeed());
          case '/addrecord':
            return MaterialPageRoute(builder: (_) => AddRecord());
          case '/scrap':
            final String bookName = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => Scrap(bookId: bookName));
          case '/scrapwhite':
            return MaterialPageRoute(builder: (_) => ScrapWhite());
          case '/writereview':
            final String bookId = settings.arguments as String;
            final String url = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => WriteReview(bookId: bookId, url: url));
          case '/mylibrary':
            return MaterialPageRoute(builder: (_) => MyLibrary());
          case '/myrecommendations':
            return MaterialPageRoute(builder: (_) => MyRecommendations());
          case '/myscraps':
            return MaterialPageRoute(builder: (_) => MyScraps());
          case '/myreviews':
            return MaterialPageRoute(builder: (_) => MyReviews());
          case '/mycompletedbooks':
            return MaterialPageRoute(builder: (_) => MyCompletedBooks());
          case '/mycomments':
            return MaterialPageRoute(builder: (_) => MyComments());
          case '/myfollowings':
            return MaterialPageRoute(builder: (_) => MyFollowings());
          case '/myfollowers':
            return MaterialPageRoute(builder: (_) => MyFollowings());
          case '/mybookfeed':
            final String bookId = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => MyBookFeed(id: bookId));
          case '/profilesettings':
            return MaterialPageRoute(builder: (_) => ProfileSettings());
          case '/loginpage2':
            return MaterialPageRoute(builder: (_) => LoginPage2());
          case '/elseprofille':
            return MaterialPageRoute(builder: (_) => ElseProfilePage());
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
                builder: (_) => MainScreen(selectedIndex: 0));
        }
      },
    );
  }
}
