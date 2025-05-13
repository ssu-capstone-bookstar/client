import 'package:bookstar_app/components/BookCard5.dart';
import 'package:bookstar_app/model/member/member_dto.dart';
import 'package:bookstar_app/model/member/profile_else_dto.dart';
import 'package:bookstar_app/pages/my_page/screen/else_follower_page.dart';
import 'package:bookstar_app/pages/my_page/screen/else_following_page.dart';
import 'package:bookstar_app/pages/my_page/state/follower_cubit/follower_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/following_cubit/following_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ElseProfilePage extends StatelessWidget {
  static const String routeName = 'elseprofile';
  static const String routePath = '/elseprofile';

  final int memberId;
  final bool isFollowing;

  const ElseProfilePage({
    super.key,
    required this.memberId,
    required this.isFollowing,
  });

  // String? profileImage;
  @override
  Widget build(BuildContext context) {
    context.read<FollowingCubit>().checkFollowing(memberId: memberId);
    context.read<ProfileCubit>()
      ..fetchProfile(memberId: memberId)
      ..fetchProfileElse(memberId: memberId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          MemberDto? memberDto = state.memberDto;
          ProfileElseDto? profileElseDto = state.profileElseDto;

          if (memberDto == null || profileElseDto == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: memberDto.profileImage.isNotEmpty
                              ? NetworkImage(memberDto.profileImage)
                                  as ImageProvider
                              : const AssetImage(
                                  'assets/images/App_LOGO_zoomout.png'),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    isFollowing
                        ? BlocBuilder<FollowingCubit, FollowingState>(
                            builder: (context, followingState) {
                              final bool currentIsFollowing =
                                  followingState.isFollow ?? false;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Text(
                                    memberDto.nickName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (currentIsFollowing) {
                                        context
                                            .read<FollowingCubit>()
                                            .deleteFollowing(
                                                followID: memberId);
                                      } else {
                                        context
                                            .read<FollowingCubit>()
                                            .addFollowing(followID: memberId);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: currentIsFollowing
                                            ? Colors
                                                .grey // 이미 팔로우 중일 때 (언팔로우 버튼)
                                            : Colors
                                                .purple, // 팔로우하지 않을 때 (팔로우 버튼)
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        currentIsFollowing ? '언팔로우' : '팔로우',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          )
                        : BlocBuilder<FollowerCubit, FollowerState>(
                            builder: (context, followerState) {
                              final bool currentIsFollower =
                                  followerState.isFollow ?? false;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Text(
                                    memberDto.nickName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (currentIsFollower) {
                                        context
                                            .read<FollowingCubit>()
                                            .deleteFollowing(
                                                followID: memberId);
                                      }
                                    },
                                    child: currentIsFollower
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '언팔로우',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  )
                                ],
                              );
                            },
                          ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "소개",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              ElseFollowingPage.routeName,
                              extra: {
                                'memberId': memberId,
                              },
                            );
                          },
                          child: Text(
                            '팔로잉 ${profileElseDto.followings}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              ElseFollowerPage.routeName,
                              extra: {
                                'memberId': memberId,
                              },
                            );
                          },
                          child: Text(
                            '팔로워 ${profileElseDto.followers}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 135, 135, 135),
                      indent: 5.0, // 왼쪽 여백 추가
                      endIndent: 5.0, // 오른쪽 여백 추가
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0), // 좌우 가장자리 간격 추가
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                              "assets/images/P1.png",
                              '서재',
                              '${profileElseDto.books}',
                              //MyLibrary.routeName,
                              context),
                          _buildStatItem(
                              "assets/images/P2.png",
                              '컬렉션',
                              '${profileElseDto.collections}',
                              //MyRecommendations.routeName,
                              context),
                          _buildStatItem(
                              "assets/images/P3.png",
                              '스크랩',
                              '${profileElseDto.scraps}',
                              //MyScraps.routeName,
                              context),
                          _buildStatItem(
                              "assets/images/P4.png",
                              '리뷰',
                              '${profileElseDto.reviews}',
                              //MyReviews.routeName,
                              context),
                          _buildStatItem(
                            "assets/images/P5.png",
                            '방명록',
                            '0',
                            //'',
                            context,
                          ),
                        ],
                      ),
                    ),
                    // Divider(
                    //   thickness: 1,
                    //   color: const Color.fromARGB(255, 135, 135, 135),
                    //   indent: 5.0, // 왼쪽 여백 추가
                    //   endIndent: 5.0, // 오른쪽 여백 추가
                    // ),
                    const SizedBox(height: 15),
                    const Text(
                      '읽고 있는 책',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: profileElseDto
                            .memberBookResponseCursorPageResponse.data.length,
                        itemBuilder: (context, index) {
                          String bookCoverImages = profileElseDto
                              .memberBookResponseCursorPageResponse
                              .data[index]
                              .bookCoverImage;
                          String bookId = profileElseDto
                              .memberBookResponseCursorPageResponse
                              .data[index]
                              .bookId;

                          return Row(
                            children: [
                              BookCard5(
                                imageUrl: bookCoverImages,
                                bookId: bookId,
                                bookWidth: 90, // 원하는 너비
                                bookHeight: 130, // 원하는 높이
                              ),
                              const SizedBox(width: 5), // 간격 추가
                            ],
                          );
                        },
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Text(
                    //   '캘린더',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // TableCalendar(
                    //   firstDay: DateTime.utc(2020, 1, 1),
                    //   lastDay: DateTime.utc(2030, 12, 31),
                    //   focusedDay: DateTime.now(),
                    //   calendarFormat: CalendarFormat.month,
                    //   headerStyle: HeaderStyle(
                    //     formatButtonVisible: false,
                    //     titleCentered: true,
                    //     titleTextFormatter: (date, locale) =>
                    //         '${date.year}.${date.month.toString().padLeft(2, '0')}',
                    //     titleTextStyle: const TextStyle(
                    //       fontSize: 18.0,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

//   Scaffold(
//     appBar: AppBar(
//       title: const Text('프로필'),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: img.isNotEmpty
//                       ? NetworkImage(img) as ImageProvider
//                       : const AssetImage(
//                           'assets/images/App_LOGO_zoomout.png'),
//                 ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(width: 5),
//                 Text(
//                   nickName,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: _toggleFollow,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: isFollowing
//                           ? Colors.purple.withValues(alpha: 0.5)
//                           : Colors.purple,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       '팔로우',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 5.0),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Text(
//                 "소개",
//                 style: TextStyle(fontSize: 14.0),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const SizedBox(width: 5),
//                 GestureDetector(
//                   onTap: () {
//                     // 다른 사용자의 팔로잉 목록 화면으로 이동
//                   },
//                   child: Text(
//                     '팔로잉 $followings',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 GestureDetector(
//                   onTap: () {
//                     // 다른 사용자의 팔로워 목록 화면으로 이동
//                   },
//                   child: Text(
//                     '팔로워 $followers',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             const Divider(
//               thickness: 1,
//               color: Color.fromARGB(255, 135, 135, 135),
//               indent: 5.0,
//               endIndent: 5.0,
//             ),
//             const SizedBox(height: 3),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildStatItem(
//                       "assets/images/P1.png", '서재', '$books', null),
//                   _buildStatItem(
//                       "assets/images/P2.png", '컬렉션', '$collections', null),
//                   _buildStatItem(
//                       "assets/images/P3.png", '스크랩', '$scraps', null),
//                   _buildStatItem(
//                       "assets/images/P4.png", '리뷰', '$reviews', null),
//                   _buildStatItem("assets/images/P5.png", '방명록', '0', null),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             const Text(
//               '읽고 있는 책',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 140,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: bookCoverImages.length,
//                 itemBuilder: (context, index) {
//                   return Row(
//                     children: [
//                       BookCard(
//                         imageUrl: bookCoverImages[index],
//                         id: int.parse(bookId[index]),
//                         bookWidth: 90,
//                         bookHeight: 130,
//                       ),
//                       const SizedBox(width: 5),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text(
//               '캘린더',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: DateTime.now(),
//               calendarFormat: CalendarFormat.month,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//                 titleTextFormatter: (date, locale) =>
//                     '${date.year}.${date.month.toString().padLeft(2, '0')}',
//                 titleTextStyle: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
Widget _buildStatItem(
  String imagePath,
  String label,
  String count,
  //String route,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () {
      //context.pushNamed(route);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath, // 이미지 경로를 받아서 표시
          width: 35, // 기존 아이콘 크기에 맞춰 조절
          height: 35,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            height: 1.0,
            color: Color.fromARGB(255, 53, 53, 53),
          ),
        ),
      ],
    ),
  );
}
