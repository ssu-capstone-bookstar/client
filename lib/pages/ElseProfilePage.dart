import 'dart:convert';
import 'dart:io';
import 'package:bookstar_app/components/BookCard.dart';
import 'package:bookstar_app/pages/ProfileSettings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ElseProfilePage extends StatefulWidget {
  @override
  _ElseProfilePageState createState() => _ElseProfilePageState();
}

class _ElseProfilePageState extends State<ElseProfilePage> {
  File profileImage = File('path');
  String nickName = '';
  String accessToken = '으잉';
  int follwings = 0;
  int followers = 10;
  int collections = 0;
  int scraps = 0;
  int reviews = 0;
  int books = 0;
  List<String> bookCoverImages = [];
  String img = "";

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Future<void> _initializeProfileData() async {
    await _loadAccessToken();
    await _fetchProfileData();
    await _loadProfileDataFromPreferences();
  }

  Future<void> _loadProfileDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        // API 요청
        final response = await http.get(
          Uri.parse('http://localhost:8080/api/v1/member/me'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // 응답 데이터를 디코딩
          final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
          nickName = decodedData['nickName'];
          img = decodedData['profileImage'];
          print('Stored User Information:');
          print('ID: ${decodedData['id']}');
          print('Nickname: ${decodedData['nickName']}');
          print('Profile Image: ${decodedData['profileImage']}');
        } else {}
      } catch (e) {}
    } else {}
  }

  Future<void> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? 'No Token Found';
    });
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse('http://localhost:8080/api/v1/member/profileInfo');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      print(response);
      final data = json.decode(response.body);
      setState(() {
        follwings = data['follwings'];
        followers = data['followers'];
        collections = data['collections'];
        scraps = data['scraps'];
        reviews = data['reviews'];
        books = data['books'];
        bookCoverImages = (data['memberBookResponseCursorPageResponse']['data']
                as List<dynamic>)
            .map((book) => book['bookCoverImage']?.toString() ?? '')
            .toList();
      });
    } else {
      print('Failed to fetch profile data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettings()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: img != null
                        ? NetworkImage(img) as ImageProvider
                        : AssetImage('assets/images/App_LOGO.png'),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('wordcloud() 컴포넌트 자리'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  Text(
                    '$nickName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        '팔로잉',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "소개",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  Text(
                    '팔로잉 $follwings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 27),
                  Text(
                    '팔로워 $followers',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.book, '서재', '$books', '/mylibrary'),
                  _buildStatItem(Icons.collections, '컬렉션', '$collections',
                      '/myrecommendations'),
                  _buildStatItem(Icons.bookmark, '스크랩', '$scraps', '/myscraps'),
                  _buildStatItem(
                      Icons.rate_review, '리뷰', '$reviews', '/myreviews'),
                  _buildStatItem(Icons.comment, '방명록', '0', ''),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '읽고 있는 책',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookCoverImages.length,
                  itemBuilder: (context, index) {
                    return BookCard(
                      imageUrl: bookCoverImages[index],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '캘린더',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      '${date.year}.${date.month.toString().padLeft(2, '0')}',
                  titleTextStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String label, String count, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: const Color.fromARGB(255, 53, 53, 53),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
