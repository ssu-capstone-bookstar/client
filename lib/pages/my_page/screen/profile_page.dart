import 'package:bookstar_app/components/BookCard5.dart';
import 'package:bookstar_app/global/functions/functions.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/model/member/member_dto.dart';
import 'package:bookstar_app/model/member/profile_else_dto.dart';
import 'package:bookstar_app/pages/my_page/ProfileSettings.dart';
import 'package:bookstar_app/pages/my_page/screen/my_follower_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_following_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_library.dart';
import 'package:bookstar_app/pages/my_page/screen/my_recommendations.dart';
import 'package:bookstar_app/pages/my_page/screen/my_reviews.dart';
import 'package:bookstar_app/pages/my_page/screen/my_scraps.dart';
import 'package:bookstar_app/pages/my_page/state/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = 'profile';
  static const String routePath = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late final int memberId;

  @override
  void initState() {
    super.initState();
    memberId = prefs.getInt('memberId')!;
    context.read<ProfileCubit>().fetchProfile(memberId: memberId);
    context.read<ProfileCubit>().fetchProfileElse(memberId: memberId);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Functions.unFocus(context: context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('프로필'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileSettings()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            MemberDto? memberDto = state.memberDto;
            ProfileElseDto? profileElseDto = state.profileElseDto;

            if (memberDto == null || profileElseDto == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(milliseconds: 300),
                    () {
                      if (!context.mounted) return;
                      context
                          .read<ProfileCubit>()
                          .fetchProfile(memberId: memberId);
                      context
                          .read<ProfileCubit>()
                          .fetchProfileElse(memberId: memberId);
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/images/App_LOGO_zoomout.png')
                                // memberDto.profileImage.isNotEmpty
                                //     ? NetworkImage(memberDto.profileImage)
                                //         as ImageProvider
                                //     : const AssetImage(
                                //         'assets/images/App_LOGO_zoomout.png'),
                                ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(),
                                  ),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            state.isWrite == true
                                ? SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.6,
                                    child: TextField(
                                      controller: _textEditingController,
                                      focusNode: _focusNode,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                : Text(
                                    memberDto.nickName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(width: 4),
                            state.isWrite == true
                                ? SizedBox(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<ProfileCubit>()
                                                .notWriting();
                                            context
                                                .read<ProfileCubit>()
                                                .patchProfileNickname(
                                                  nickname:
                                                      _textEditingController
                                                          .text,
                                                  memberId: memberId,
                                                );
                                          },
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 24,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<ProfileCubit>()
                                                .notWriting();
                                          },
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            size: 24,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      context.read<ProfileCubit>().writing();

                                      _textEditingController.text =
                                          memberDto.nickName;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (mounted) {
                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 1.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const TextField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 1.0),
                              hintText: "소개",
                              border: InputBorder.none,
                            ),
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
                                context
                                    .pushNamed(MyFollowingPage.routeName)
                                    .then(
                                  (value) {
                                    if (!context.mounted) return;
                                    context
                                        .read<ProfileCubit>()
                                        .fetchProfileElse(memberId: memberId);
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
                                context.pushNamed(MyFollowerPage.routeName);
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
                                  MyLibrary.routeName,
                                  context),
                              _buildStatItem(
                                  "assets/images/P2.png",
                                  '컬렉션',
                                  '${profileElseDto.collections}',
                                  MyRecommendations.routeName,
                                  context),
                              _buildStatItem(
                                  "assets/images/P3.png",
                                  '스크랩',
                                  '${profileElseDto.scraps}',
                                  MyScraps.routeName,
                                  context),
                              _buildStatItem(
                                  "assets/images/P4.png",
                                  '리뷰',
                                  '${profileElseDto.reviews}',
                                  MyReviews.routeName,
                                  context),
                              _buildStatItem("assets/images/P5.png", '방명록', '0',
                                  '', context),
                            ],
                          ),
                        ),
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
                                .memberBookResponseCursorPageResponse
                                .data
                                .length,
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
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String imagePath,
    String label,
    String count,
    String route,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(route);
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
}
