import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('http://15.164.30.67:8080/api/v1/follow/followers/1');
    final headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJrYWthbyIsImlhdCI6MTczNDE3NTU5OSwiZXhwIjoxNzM0MjYxOTk5LCJzdWIiOiIzODI0MDIwMTkwIiwicHJvdmlkZXJJZCI6IjM4MjQwMjAxOTAiLCJpZCI6MSwicm9sZSI6IlVTRVIifQ.0uDr9LHFmub8vdj2gIKRN-gxhWqU0FMB1GyB3p-SVY0'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final decodedData =
            jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8 디코딩 및 JSON 변환
        setState(() {
          followers = decodedData;
          isLoading = false;
        });
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
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      final follower = followers[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(follower['profileImage']),
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
                      );
                    },
                  ),
                ),
    );
  }
}
