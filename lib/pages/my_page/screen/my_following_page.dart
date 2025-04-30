import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/my_page/ElseProfilePage.dart';
import 'package:bookstar_app/pages/my_page/state/following_cubit/following_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFollowingPage extends StatelessWidget {
  static const String routeName = 'myfollowing';
  static const String routePath = '/myfollowing';

  const MyFollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? memberId = prefs.getInt('memberId');
    return BlocProvider(
      create: (context) =>
          FollowingCubit()..fetchFolloingList(memberId: memberId!),
      child: BlocBuilder<FollowingCubit, FollowingState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('팔로잉 목록'),
              centerTitle: true,
            ),
            body: state.followingList == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.followingList!.isEmpty
                    ? const Center(
                        child: Text('No following found.'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: state.followingList!.length,
                          itemBuilder: (context, index) {
                            final following = state.followingList![index];
                            return GestureDetector(
                              // 클릭 이벤트 추가
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ElseProfilePage(
                                      memberId: following.memberId,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: following
                                            .profileImage.isNotEmpty
                                        ? NetworkImage(following.profileImage)
                                        : const AssetImage(
                                                "assets/images/App_LOGO_zoomout.png")
                                            as ImageProvider,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    following.nickname,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          );
        },
      ),
    );
  }
}
