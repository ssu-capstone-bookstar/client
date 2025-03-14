import 'dart:convert';
import 'package:bookstar_app/components/BookCard.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';

class ElseProfilePage extends StatefulWidget {
  final int memberId;

  ElseProfilePage({required this.memberId});

  @override
  _ElseProfilePageState createState() => _ElseProfilePageState();
}

class _ElseProfilePageState extends State<ElseProfilePage> {
  String? profileImage;
  String nickName = '';
  String accessToken = '';
  int followings = 0;
  int followers = 0;
  int collections = 0;
  int scraps = 0;
  int reviews = 0;
  int books = 0;
  bool isFollowing = false;
  List<String> bookCoverImages = [];
  List<String> bookId = [];
  String img = "";
  String? wordcloudImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Future<void> _initializeProfileData() async {
    await _loadAccessToken();
    await _fetchProfileData();
    await _fetchProfile();
  }

  Future<void> _loadAccessToken() async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    setState(() {
      accessToken = token!;
    });
  }

  Future<void> _fetchProfile() async {
    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/member/${widget.memberId}');
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final data = json.decode(utf8Body);
      if (mounted) {
        setState(() {
          nickName = data['nickName'] ?? 'noname';
          profileImage = data['profileImage'] ?? "";
        });
      }
    } else {
      print('Failed to fetch profile: ${response.statusCode}');
    }
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse(
        'http://15.164.30.67:8080/api/v1/member/${widget.memberId}/profileInfo');
    final response = await http.get(
      url,
      // headers: {
      //   HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      // },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (mounted) {
        setState(() {
          print("Setting state with new values");
          followings = data['follwings'] ?? 0;
          followers = data['followers'] ?? 0;
          collections = data['collections'] ?? 0;
          scraps = data['scraps'] ?? 0;
          reviews = data['reviews'] ?? 0;
          books = data['books'] ?? 0;
          img = data['profileImage'] ?? '';
          bookCoverImages = (data['memberBookResponseCursorPageResponse']
                  ['data'] as List<dynamic>)
              .map((book) => book['bookCoverImage']?.toString() ?? '')
              .toList();
          bookId = (data['memberBookResponseCursorPageResponse']['data']
                  as List<dynamic>)
              .map((book) => book['bookId']?.toString() ?? '')
              .toList();
        });
      }
    } else {
      print('Failed to fetch profile data: ${response.statusCode}');
    }
  }

  Future<void> _toggleFollow() async {
    final code = Provider.of<UserProvider>(context, listen: false).accessToken;
    print("accessToken: $code");

    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/follow/${widget.memberId}');

    try {
      http.Response response;
      if (isFollowing) {
        // Unfollow
        response = await http.delete(
          url,
          headers: {
            'Authorization': 'Bearer $code',
          },
        );
      } else {
        // Follow
        response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $code',
          },
        );
      }

      if (response.statusCode == 200) {
        setState(() {
          isFollowing = !isFollowing;
          if (isFollowing) {
            followers++;
          } else {
            followers--;
          }
        });

        // Show popup
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFollowing ? '팔로우 완료' : '팔로우 해제'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print('Failed to toggle follow: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
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
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleFollow,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: isFollowing
                            ? Colors.purple.withOpacity(0.5)
                            : Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '팔로우',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "소개",
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
                      // 다른 사용자의 팔로잉 목록 화면으로 이동
                    },
                    child: Text(
                      '팔로잉 $followings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      // 다른 사용자의 팔로워 목록 화면으로 이동
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
                indent: 5.0,
                endIndent: 5.0,
              ),
              SizedBox(height: 3),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                        "assets/images/P1.png", '서재', '$books', null),
                    _buildStatItem(
                        "assets/images/P2.png", '컬렉션', '$collections', null),
                    _buildStatItem(
                        "assets/images/P3.png", '스크랩', '$scraps', null),
                    _buildStatItem(
                        "assets/images/P4.png", '리뷰', '$reviews', null),
                    _buildStatItem("assets/images/P5.png", '방명록', '0', null),
                  ],
                ),
              ),
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
                        BookCard(
                          imageUrl: bookCoverImages[index],
                          id: int.parse(bookId[index]),
                          bookWidth: 90,
                          bookHeight: 130,
                        ),
                        SizedBox(width: 5),
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
      String imagePath, String label, String count, String? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 35,
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
