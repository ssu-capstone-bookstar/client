import 'dart:convert';

import 'package:bookstar_app/global/functions/functions.dart';
import 'package:bookstar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WriteReviewPage extends StatefulWidget {
  final int bookId;

  const WriteReviewPage({
    super.key,
    required this.bookId,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
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
    String? accessToken = await secureStorage.read(key: 'accessToken');
    final bookId = widget.bookId;
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("리뷰 작성"),
        actions: [
          IconButton(
            onPressed: _submitReview,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => Functions.unFocus(context: context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
