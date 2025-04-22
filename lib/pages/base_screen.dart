import 'package:bookstar_app/global/Index_cubit/index_cubit.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
import 'package:bookstar_app/pages/my_page/ProfilePage.dart';
import 'package:bookstar_app/pages/search/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = context.read<IndexCubit>().state.index;
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // 간격 고정
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              currentIndex == 0
                  ? 'assets/images/C_Search_ICON.png' // 활성화된 아이콘
                  : 'assets/images/Search_ICON.png', // 비활성화된 아이콘
              width: 27,
              height: 27,
            ),
            label: '', // 레이블 제거
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              currentIndex == 1
                  ? 'assets/images/C_Home_ICON.png'
                  : 'assets/images/Home_ICON.png',
              width: 27,
              height: 27,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              currentIndex == 2
                  ? 'assets/images/C_User_ICON.png'
                  : 'assets/images/User_ICON.png',
              width: 27,
              height: 27,
            ),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          context.read<IndexCubit>().setIndex(index: index);
          // _onItemTapped(index);
          // 버튼 클릭 효과를 위한 애니메이션 추가
          switch (index) {
            case 0:
              context.go(SearchPage.routePath);
              break;
            case 1:
              context.go(HomePage.routePath);
              break;
            case 2:
              context.go(ProfilePage.routePath);
              break;
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue, // 선택된 아이템 색상 (아이콘에 영향 없음)
      ),
    );
  }
}
