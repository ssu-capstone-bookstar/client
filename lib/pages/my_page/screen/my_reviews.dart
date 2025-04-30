import 'dart:convert';

import 'package:bookstar_app/components/ReviewCard.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyReviews extends StatelessWidget {
  static const String routeName = 'myreviews';
  static const String routePath = '/myreviews';

  const MyReviews({super.key});

  Future<Map<String, dynamic>> fetchMyReviewData(BuildContext context) async {
    final memberId = Provider.of<UserProvider>(context, listen: false).userId;
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/review/user/$memberId');
    print('Fetching Review data for id: $memberId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print('Review response: $decodedData');
      return decodedData;
    } else {
      print('Failed to fetch Review data: ${response.statusCode}');
      throw Exception('Failed to load Review data');
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
        title: const Text('리뷰'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMyReviewData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['data'] == null ||
              snapshot.data!['data'].isEmpty) {
            return const Center(child: Text('No reviews found.'));
          } else {
            final List<dynamic> reviews =
                snapshot.data!['data']['content'] ?? [];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reviews
                      .expand((review) => [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _formatDate(review['reviewUploadTime']),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            ReviewCard(
                              reviewId: review['reviewId'],
                              memberId: review['memberId'],
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
