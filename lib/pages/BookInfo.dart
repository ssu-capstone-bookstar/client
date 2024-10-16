import 'package:bookstar_app/components/FloatingActionMenu2.dart';
import 'package:flutter/material.dart';
import 'package:bookstar_app/components/FloatingActionMenu3.dart';

class BookInfo extends StatefulWidget {
  final String bookName;

  BookInfo({required this.bookName});

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Info'),
      ),
      body: Center(
        child: Text('Information about: ${widget.bookName}'),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 80.0),
            child: FloatingActionMenu3(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionMenu2(),
          ),
        ],
      ),
    );
  }
}
