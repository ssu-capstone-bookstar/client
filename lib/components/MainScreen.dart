import 'package:bookstar_app/pages/HomePage.dart';
import 'package:bookstar_app/pages/SearchPage.dart';
import 'package:bookstar_app/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex;

  MainScreen({this.selectedIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  static List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // 간격 고정
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'assets/images/C_Search_ICON.png' // 활성화된 아이콘
                  : 'assets/images/Search_ICON.png', // 비활성화된 아이콘
              width: 27,
              height: 27,
            ),
            label: '', // 레이블 제거
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1
                  ? 'assets/images/C_Home_ICON.png'
                  : 'assets/images/Home_ICON.png',
              width: 27,
              height: 27,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2
                  ? 'assets/images/C_User_ICON.png'
                  : 'assets/images/User_ICON.png',
              width: 27,
              height: 27,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
          // 버튼 클릭 효과를 위한 애니메이션 추가
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue, // 선택된 아이템 색상 (아이콘에 영향 없음)
      ),
    );
  }
}
