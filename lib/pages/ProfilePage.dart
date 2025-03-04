import 'dart:convert';
import 'dart:io';
import 'package:bookstar_app/components/BookCard.dart';
import 'package:bookstar_app/components/BookCard5.dart';
import 'package:bookstar_app/pages/ProfileSettings.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? profileImage;
  String nickName = '';
  String accessToken = '';
  int follwings = 0;
  int followers = 10;
  int collections = 0;
  int scraps = 0;
  int reviews = 0;
  int books = 0;
  int userId = 0;
  List<String> bookCoverImages = [];
  List<String> bookId = [];
  String img = "";
  String? wordcloudImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    // _fetchWordcloudImage();
  }

  Future<void> _initializeProfileData() async {
    await _loadAccessToken();
    await _fetchProfileData();
    await _loadProfileDataFromPreferences();
  }

  Future<void> _loadProfileDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nickName = prefs.getString('nickName') ?? '';
      accessToken = prefs.getString('accessToken') ?? '';
      userId = prefs.getInt('userId') ?? 0;

      String? profileImagePath = prefs.getString('profileImage');
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        profileImage = File(profileImagePath);
      }
    });
  }

  Future<void> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? 'No Token Found';
    });
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse('http://15.164.30.67:8080/api/v1/member/profileInfo');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
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
        bookId = (data['memberBookResponseCursorPageResponse']['data']
                as List<dynamic>)
            .map((book) => book['bookId']?.toString() ?? '')
            .toList();
      });
    } else {
      print('Failed to fetch profile data: ${response.statusCode}');
    }
  }

  Future<void> _fetchWordcloudImage() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    try {
      final response = await http.get(
        Uri.parse(
            'http://15.164.30.67:8000/generate-presigned-url?user_id=1'), //워드클라우드 배포 x
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          wordcloudImageUrl = data['url'];
        });
        print('fetch wordcloud image success!');
      } else {
        print('Failed to fetch wordcloud image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wordcloud image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
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
                    backgroundImage: img.isNotEmpty
                        ? NetworkImage(img) as ImageProvider
                        : AssetImage('assets/images/App_LOGO_zoomout.png'),
                  ),
                  SizedBox(width: 20),
                  // Expanded(
                  //   child: Container(
                  //     height: 100,
                  //     decoration: BoxDecoration(
                  //       color: const Color.fromARGB(0, 224, 224, 224),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Center(
                  //       child: wordcloudImageUrl != null
                  //           ? Image.network(wordcloudImageUrl!)
                  //           : CircularProgressIndicator(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 20),
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
                ],
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                    hintText: "소개",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
              ),

              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/myfollowings');
                    },
                    child: Text(
                      '팔로잉 $follwings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 7), // 간격 조정
                  // Container(
                  //   width: 2, // 막대의 굵기 조절
                  //   height: 14, // 막대의 높이 조절 (텍스트 높이에 맞춤)
                  //   color: const Color.fromARGB(255, 64, 64, 64), // 색상 조절 가능
                  // ),
                  SizedBox(width: 7),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/myfollowers'); // 팔로워 클릭 시 이동
                    },
                    child: Text(
                      '팔로워 $followers',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(
                thickness: 1,
                color: const Color.fromARGB(255, 135, 135, 135),
                indent: 5.0, // 왼쪽 여백 추가
                endIndent: 5.0, // 오른쪽 여백 추가
              ),
              SizedBox(height: 3),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0), // 좌우 가장자리 간격 추가
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                        "assets/images/P1.png", '서재', '$books', '/mylibrary'),
                    _buildStatItem("assets/images/P2.png", '컬렉션',
                        '$collections', '/myrecommendations'),
                    _buildStatItem(
                        "assets/images/P3.png", '스크랩', '$scraps', '/myscraps'),
                    _buildStatItem(
                        "assets/images/P4.png", '리뷰', '$reviews', '/myreviews'),
                    _buildStatItem("assets/images/P5.png", '방명록', '0', ''),
                  ],
                ),
              ),
              // Divider(
              //   thickness: 1,
              //   color: const Color.fromARGB(255, 135, 135, 135),
              //   indent: 5.0, // 왼쪽 여백 추가
              //   endIndent: 5.0, // 오른쪽 여백 추가
              // ),
              SizedBox(height: 15),
              Text(
                '읽고 있는 책',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookCoverImages.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        BookCard5(
                          imageUrl: bookCoverImages[index],
                          bookId: bookId[index],
                          bookWidth: 90, // 원하는 너비
                          bookHeight: 130, // 원하는 높이
                        ),
                        SizedBox(width: 5), // 간격 추가
                      ],
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
      String imagePath, String label, String count, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath, // 이미지 경로를 받아서 표시
            width: 35, // 기존 아이콘 크기에 맞춰 조절
            height: 35,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          SizedBox(height: 3),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              height: 1.0,
              color: const Color.fromARGB(255, 53, 53, 53),
            ),
          ),
        ],
      ),
    );
  }
}
