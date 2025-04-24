import 'dart:convert';

import 'package:bookstar_app/components/BookCard3.dart';
import 'package:bookstar_app/pages/my_page/ElseProfilePage.dart';
import 'package:bookstar_app/pages/my_page/profile_page.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CustomSearchBar extends SearchDelegate {
  int currentPage = 1;
  bool hasNext = false;
  List<Map<String, String>> books = [];
  List<Map<String, dynamic>> users = [];
  int searchType = 0; // 0: 책 검색, 1: 유저 검색

  Future<void> fetchBooks(String query, {bool isNewSearch = false}) async {
    if (isNewSearch) {
      currentPage = 1;
      books.clear();
    }

    final String url =
        'http://15.164.30.67:8080/api/v1/search/books/aladin?query=$query&start=$currentPage';

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

  Future<void> fetchUsers(BuildContext context, String query) async {
    users.clear();

    final String url = 'http://15.164.30.67:8080/api/v1/search/users/$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedData["statusResponse"]["resultCode"] == "B000") {
          List userData = decodedData["data"];

          // ✅ Provider에서 로그인한 유저의 ID 가져오기
          final int userId =
              Provider.of<UserProvider>(context, listen: false).userId ?? -1;
          print("userid: $userId");

          for (var user in userData) {
            bool isMe = user["memberId"] == userId; // ✅ 현재 로그인한 유저인지 확인
            print("user: ${user["memberId"]}");
            print("isMe: $isMe");

            users.add({
              "memberId": user["memberId"],
              "nickName": user["nickName"],
              "profileImg": user["profileImg"],
              "isMe": isMe,
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching users: $e");
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
          users.clear(); // 사용자 결과 초기화
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
    if (searchType == 0) {
      return FutureBuilder(
        future: fetchBooks(query, isNewSearch: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (books.isEmpty) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: Text('검색 결과가 없습니다.')),
            );
          }
          return _buildSearchNavigationWithContent(
            context,
            _buildBookList(context),
          );
        },
      );
    } else {
      return FutureBuilder(
        future: fetchUsers(context, query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (users.isEmpty) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: Text('사용자 검색 결과가 없습니다.')),
            );
          }
          return _buildSearchNavigationWithContent(
            context,
            _buildUserList(context),
          );
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildSearchNavigationWithContent(
        context,
        const Center(child: Text('검색어를 입력하세요.')),
      );
    }

    if (searchType == 0) {
      return FutureBuilder(
        future: fetchBooks(query, isNewSearch: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (books.isEmpty) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: Text('추천 검색어가 없습니다.')),
            );
          }
          return _buildSearchNavigationWithContent(
            context,
            _buildBookList(context),
          );
        },
      );
    } else {
      return FutureBuilder(
        future: fetchUsers(context, query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (users.isEmpty) {
            return _buildSearchNavigationWithContent(
              context,
              const Center(child: Text('사용자 검색 결과가 없습니다.')),
            );
          }
          return _buildSearchNavigationWithContent(
            context,
            _buildUserList(context),
          );
        },
      );
    }
  }

  Widget _buildSearchNavigation(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                searchType = 0;
                showResults(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: searchType == 0
                          ? const Color.fromARGB(255, 120, 24, 184)
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  '책 검색',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        searchType == 0 ? FontWeight.bold : FontWeight.normal,
                    color: searchType == 0
                        ? const Color.fromARGB(255, 120, 24, 184)
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                searchType = 1;
                showResults(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: searchType == 1
                          ? const Color.fromARGB(255, 120, 24, 184)
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  '유저 검색',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        searchType == 1 ? FontWeight.bold : FontWeight.normal,
                    color: searchType == 1
                        ? const Color.fromARGB(255, 120, 24, 184)
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchNavigationWithContent(
      BuildContext context, Widget content) {
    return Column(
      children: [
        _buildSearchNavigation(context),
        Expanded(child: content),
      ],
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
              id: int.tryParse(book["id"] ?? '0') ?? 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: () {
            if (user["isMe"]) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ElseProfilePage(memberId: user["memberId"]),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user["profileImg"] != null &&
                          user["profileImg"].isNotEmpty
                      ? NetworkImage(user["profileImg"])
                      : const AssetImage('assets/images/App_LOGO_zoomout.png'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        user["nickName"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user["isMe"])
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 217, 187, 251),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'me',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 163, 33, 243),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchNextPage() async {
    currentPage++;
    await fetchBooks(query);
  }
}
