import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bookstar_app/pages/WriteReview.dart';
import 'package:bookstar_app/pages/Scrap.dart';

class FloatingActionMenu4 extends StatefulWidget {
  final int bookId;

  FloatingActionMenu4({required this.bookId});

  @override
  _FloatingActionMenu4State createState() => _FloatingActionMenu4State();
}

class _FloatingActionMenu4State extends State<FloatingActionMenu4> {
  bool showLabels = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 30), () {
      setState(() {
        showLabels = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: Icon(Icons.rate_review),
          label: '리뷰 쓰기',
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WriteReview(
                        bookId: widget.bookId,
                        url: "hhtt",
                      )),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.bookmark),
          label: '스크랩',
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scrap(
                        bookId: widget.bookId,
                      )),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.check),
          label: '읽음 표시',
          backgroundColor: Colors.blue,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('표시되었습니다!')),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.done_all),
          label: '완독',
          backgroundColor: Colors.blue,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('완독!')),
            );
          },
        ),
      ],
    );
  }
}
