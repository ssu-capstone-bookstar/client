import 'package:bookstar_app/global/state/Index_cubit/index_cubit.dart';
import 'package:bookstar_app/pages/my_page/screen/my_library.dart';
import 'package:bookstar_app/pages/search/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class HomeFloatingActionbutton extends StatelessWidget {
  const HomeFloatingActionbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.grey.shade800, // 어두운 회색 배경색으로 변경
      iconTheme: const IconThemeData(size: 32),
      foregroundColor: Colors.white,
      overlayOpacity: 0.0, // 오버레이 제거로 덜 방해되도록 설정
      spacing: 10, // 버튼 사이 간격 설정
      spaceBetweenChildren: 8, // 하위 버튼 간격 설정
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.book,
            size: 30,
            color: Colors.white,
          ),
          label: '책 추가',
          backgroundColor: Colors.grey.shade700, // 하위 버튼 색상 조정
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.grey.shade700,
          shape: const CircleBorder(), // SpeedDial과 동일한 원형 버튼 스타일 적용
          onTap: () {
            context.read<IndexCubit>().setIndex(index: 0);
            context.goNamed(SearchPage.routeName);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.edit, size: 30, color: Colors.white),
          label: '기록 추가',
          backgroundColor: Colors.grey.shade700, // 하위 버튼 색상 조정
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.grey.shade700,
          shape: const CircleBorder(), // SpeedDial과 동일한 원형 버튼 스타일 적용
          onTap: () {
            context.read<IndexCubit>().setIndex(index: 2);
            context.goNamed(MyLibrary.routeName);
          },
        ),
      ],
    );
  }
}
