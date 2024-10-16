import 'package:bookstar_app/components/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bookstar_app/pages/AddRecord.dart';

class FloatingActionMenu1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: Icon(Icons.book),
          label: '책 추가',
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(selectedIndex: 1)),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: '기록 추가',
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecord()),
            );
          },
        ),
      ],
    );
  }
}
