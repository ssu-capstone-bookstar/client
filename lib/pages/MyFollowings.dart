import 'dart:convert';
import 'package:bookstar_app/pages/ElseProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';

class MyFollowings extends StatefulWidget {
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<MyFollowings> {
  List<dynamic> followers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/follow/followers/$userId');
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final decodedData =
            jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8 디코딩 및 JSON 변환
        setState(() {
          followers = decodedData;
          isLoading = false;
        });
        print(decodedData);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load followers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팔로워 목록'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : followers.isEmpty
              ? Center(child: Text('No followers found.'))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      final follower = followers[index];
                      return GestureDetector(
                        // 클릭 이벤트 추가
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ElseProfilePage(
                                  memberId: follower['memberId']),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: follower['profileImage'] !=
                                          null &&
                                      follower['profileImage'].isNotEmpty
                                  ? NetworkImage(follower['profileImage'])
                                  : AssetImage(
                                          "assets/images/App_LOGO_zoomout.png")
                                      as ImageProvider,
                            ),
                            SizedBox(height: 8),
                            Text(
                              follower['nickname'],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
