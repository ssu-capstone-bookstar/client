import 'package:bookstar_app/components/MainScreen.dart';
import 'package:bookstar_app/pages/AddRecord.dart';
import 'package:bookstar_app/pages/BookInfo.dart';
import 'package:bookstar_app/pages/HomePage.dart';
import 'package:bookstar_app/pages/LoginPage.dart';
import 'package:bookstar_app/pages/MyBookFeed.dart';
import 'package:bookstar_app/pages/MyComments.dart';
import 'package:bookstar_app/pages/MyCompletedBooks.dart';
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book SNS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // 초기 페이지 설정
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
            final String bookName = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => BookInfo(bookName: bookName));
          case '/newsfeed':
            return MaterialPageRoute(builder: (_) => NewsFeed());
          case '/addrecord':
            return MaterialPageRoute(builder: (_) => AddRecord());
          case '/scrap':
            return MaterialPageRoute(builder: (_) => Scrap());
          case '/scrapwhite':
            return MaterialPageRoute(builder: (_) => ScrapWhite());
          case '/writereview':
            final String bookName = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => WriteReview(bookName: bookName));
          case '/mylibrary':
            return MaterialPageRoute(builder: (_) => MyLibrary());
          case '/myrecommendations':
            final String recommendingId = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) =>
                    MyRecommendations(recommendingId: recommendingId));
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
            return MaterialPageRoute(builder: (_) => MyBookFeed());
          case '/profilesettings':
            return MaterialPageRoute(builder: (_) => ProfileSettings());
          default:
            return MaterialPageRoute(
                builder: (_) => MainScreen(selectedIndex: 0));
        }
      },
    );
  }
}
