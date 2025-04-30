import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/pages/my_page/ElseProfilePage.dart';
import 'package:bookstar_app/pages/my_page/state/follower_cubit/follower_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFollowerPage extends StatelessWidget {
  static const String routeName = 'myfollower';
  static const String routePath = '/myfollower';

  const MyFollowerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? memberId = prefs.getInt('memberId');
    return BlocProvider(
      create: (context) =>
          FollowerCubit()..fetchFollowerList(memberId: memberId!),
      child: BlocBuilder<FollowerCubit, FollowerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('팔로워 목록'),
              centerTitle: true,
            ),
            body: state.followerList == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.followerList!.isEmpty
                    ? const Center(child: Text('No followers found.'))
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
                          itemCount: state.followerList!.length,
                          itemBuilder: (context, index) {
                            final follower = state.followerList![index];
                            return GestureDetector(
                              // 클릭 이벤트 추가
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ElseProfilePage(
                                      memberId: follower.memberId,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: follower
                                            .profileImage.isNotEmpty
                                        ? NetworkImage(follower.profileImage)
                                        : const AssetImage(
                                                "assets/images/App_LOGO_zoomout.png")
                                            as ImageProvider,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    follower.nickname,
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
