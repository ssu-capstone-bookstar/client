import 'dart:convert';

import 'package:bookstar_app/components/BookCard3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomSearchBar extends SearchDelegate {
  int currentPage = 1;
  bool hasNext = false;
  List<Map<String, String>> books = [];

  Future<void> fetchBooks(String query, {bool isNewSearch = false}) async {
    if (isNewSearch) {
      currentPage = 1;
      books.clear();
    }

    final String url =
        'http://localhost:8080/api/v1/search/books/aladin?query=$query&start=$currentPage';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedData["statusResponse"]["resultCode"] == "B000") {
          List newBooks = decodedData["data"]["data"];
          for (var book in newBooks) {
            books.add({
              "imageUrl": book["bookCover"],
              "title": book["title"],
              "author": book["author"],
              "year": book["pubDate"],
              "id": book["bookId"].toString(),
            });
          }
          hasNext = decodedData["data"]["hasNext"];
        }
      }
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // 검색어 초기화
          books.clear(); // 기존 결과 초기화
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // 검색창 닫기
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: fetchBooks(query, isNewSearch: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (books.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다.'));
        }
        return _buildBookList(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('검색어를 입력하세요.'));
    }
    return FutureBuilder(
      future: fetchBooks(query, isNewSearch: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (books.isEmpty) {
          return const Center(child: Text('추천 검색어가 없습니다.'));
        }
        return _buildBookList(context);
      },
    );
  }

  Widget _buildBookList(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            hasNext) {
          _fetchNextPage();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: BookCard3(
              imageUrl: book["imageUrl"] ?? "",
              title: book["title"] ?? "",
              author: book["author"] ?? "",
              year: book["year"] ?? "",
              id: book["id"] ?? "",
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchNextPage() async {
    currentPage++;
    await fetchBooks(query);
  }
}
