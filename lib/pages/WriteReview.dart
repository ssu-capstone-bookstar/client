import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WriteReview extends StatefulWidget {
  final int bookId;
  final String? url;

  const WriteReview({super.key, required this.bookId, required this.url});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final TextEditingController _reviewController = TextEditingController();
  String _privacy = "PUBLIC";
  String _rating = "5"; // 기본 값
  String _title = "책 제목";
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    getBookInfo();
  }

  Future<void> getBookInfo() async {
    final url =
        Uri.parse('http://15.164.30.67:8080/api/v1/books/${widget.bookId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          _title = decodedData['data']['title'] ?? "책 제목";
          _imageUrl = decodedData['data']['imageUrl'] ?? "";
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("책 정보를 불러오지 못했습니다.")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("오류 발생: $e")));
    }
  }

  Future<void> _submitReview() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? 'No Token Found';
    final bookId = widget.bookId;
    print("accessToken: $accessToken");
    print("bookId: ${widget.bookId}");
    const url = "http://15.164.30.67:8080/api/v1/review";
    final headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json"
    };

    final body = jsonEncode({
      "bookId": bookId,
      "rating": int.tryParse(_rating) ?? 5,
      "content": _reviewController.text,
      "privacy": _privacy
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("리뷰가 성공적으로 제출되었습니다.")));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("리뷰 제출에 실패했습니다.")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("오류 발생: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("리뷰 작성"),
        actions: [
          IconButton(
            onPressed: _submitReview,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: _imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(_imageUrl), fit: BoxFit.cover)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _rating,
              items: ["1", "2", "3", "4", "5"]
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text("$value 점"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _rating = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("공개 설정:"),
                DropdownButton<String>(
                  value: _privacy,
                  items: ["PUBLIC", "PRIVATE"]
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value == "PUBLIC" ? "공개" : "비공개"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _privacy = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "여기에 작성해주세요.",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
