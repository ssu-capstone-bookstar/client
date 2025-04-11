import 'dart:convert';

import 'package:bookstar_app/components/BookCard.dart';
import 'package:bookstar_app/components/BookCard3.dart';
import 'package:bookstar_app/components/CustomSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ImagePicker _picker = ImagePicker();
  int cursor = 1;
  List<Map<String, dynamic>> books = [];
  bool isLoading = false;

  Future<void> _fetchBooks() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://15.164.30.67:8080/api/v1/search/bestseller/aladin?start=$cursor'),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        final newBooks = (decodedData['data'] as List).map((book) {
          return {
            'id': book['bookId'],
            'imageUrl': book['bookCover'],
            'title': book['title'],
            'author': book['author'],
            'year': book['pubDate'],
          };
        }).toList();

        setState(() {
          books.addAll(newBooks);
          cursor++;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearchBar(),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  '검색창',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // _openCamera(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchBooks();
          }
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '최근 본 작품',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("기록 삭제"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text(
                      '기록 삭제',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return const BookCard(
                      imageUrl:
                          'https://image.aladin.co.kr/product/29137/2/coversum/8936434594_2.jpg',
                      id: 9,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '추천 책',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: books.map((book) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: BookCard3(
                      imageUrl: book['imageUrl'] ?? "",
                      title: book['title'] ?? "",
                      author: book['author'] ?? "",
                      year: book['year'] ?? "",
                      id: book['id'] ?? 0,
                    ),
                  );
                }).toList(),
              ),
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
