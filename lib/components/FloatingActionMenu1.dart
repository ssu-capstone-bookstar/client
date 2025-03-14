import 'dart:async';
import 'package:bookstar_app/pages/MyLibrary.dart';
import 'package:bookstar_app/pages/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingActionMenu1 extends StatefulWidget {
  @override
  _FloatingActionMenu1State createState() => _FloatingActionMenu1State();
}

class _FloatingActionMenu1State extends State<FloatingActionMenu1> {
  bool showLabels = true;

  @override
  void initState() {
    super.initState();
    // 타이머를 설정하여 1초 후에 라벨을 숨김
    Timer(Duration(seconds: 1), () {
      if (mounted) {
        // 위젯이 여전히 트리에 있을 때만 setState 호출
        setState(() {
          showLabels = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.grey.shade800, // 어두운 회색 배경색으로 변경
      iconTheme: IconThemeData(size: 32),
      foregroundColor: Colors.white,
      overlayOpacity: 0.0, // 오버레이 제거로 덜 방해되도록 설정
      spacing: 10, // 버튼 사이 간격 설정
      spaceBetweenChildren: 8, // 하위 버튼 간격 설정
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.book,
            size: 30,
            color: Colors.white,
          ),
          label: showLabels ? '책 추가' : null,
          backgroundColor: Colors.grey.shade700, // 하위 버튼 색상 조정
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.grey.shade700,
          shape: CircleBorder(), // SpeedDial과 동일한 원형 버튼 스타일 적용
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.edit, size: 30, color: Colors.white),
          label: showLabels ? '기록 추가' : null,
          backgroundColor: Colors.grey.shade700, // 하위 버튼 색상 조정
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.grey.shade700,
          shape: CircleBorder(), // SpeedDial과 동일한 원형 버튼 스타일 적용
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyLibrary()),
            );
          },
        ),
      ],
    );
  }
}
