import 'dart:convert';

import 'package:bookstar_app/pages/scrap/screen/scrap_card_screen.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyScraps extends StatelessWidget {
  static const String routeName = 'myscraps';
  static const String routePath = '/myscraps';

  const MyScraps({super.key});

  Future<Map<String, dynamic>> fetchMyScrapData(BuildContext context) async {
    final memberId = Provider.of<UserProvider>(context, listen: false).userId;
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/scrap/user/$memberId');
    print('Fetching MyScrap data for id: $memberId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print('MyScrap response: $decodedData');
      return decodedData;
    } else {
      print('Failed to fetch MyScrap data: ${response.statusCode}');
      throw Exception('Failed to load MyScrap data');
    }
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '';
    }

    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스크랩'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMyScrapData(context),
        builder: (context, snapshot) {
          final memberId =
              Provider.of<UserProvider>(context, listen: false).userId;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['data'] == null ||
              snapshot.data!['data'].isEmpty) {
            return const Center(child: Text('No scraps found.'));
          } else {
            final List<dynamic> scraps =
                snapshot.data!['data']['content'] ?? [];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: scraps
                      .expand((scrap) => [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _formatDate(scrap['scrapUploadTime']),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            ScrapCardScreen(
                              scrapId: scrap['scrapId'],
                              memberId: memberId ?? 0,
                            ),
                          ])
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
