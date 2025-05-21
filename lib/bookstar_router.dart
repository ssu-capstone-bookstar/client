import 'package:bookstar_app/global/state/collection_cubit/collection_cubit.dart';
import 'package:bookstar_app/global/state/single_book_cubit/single_book_cubit.dart';
import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:bookstar_app/pages/base_screen.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
import 'package:bookstar_app/pages/home/state/pheed_cubit/pheed_cubit.dart';
import 'package:bookstar_app/pages/my_page/screen/else_follower_page.dart';
import 'package:bookstar_app/pages/my_page/screen/else_following_page.dart';
import 'package:bookstar_app/pages/my_page/screen/else_profile_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_collection_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_feed_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_follower_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_following_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_library.dart';
import 'package:bookstar_app/pages/my_page/screen/my_reviews.dart';
import 'package:bookstar_app/pages/my_page/screen/my_scraps.dart';
import 'package:bookstar_app/pages/my_page/screen/profile_page.dart';
import 'package:bookstar_app/pages/my_page/state/follower_cubit/follower_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/following_cubit/following_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/profile_cubit/profile_cubit.dart';
import 'package:bookstar_app/pages/search/screen/aladin_book_screen.dart';
import 'package:bookstar_app/pages/search/screen/search_page.dart';
import 'package:bookstar_app/pages/search/state/search_cubit/search_cubit.dart';
import 'package:bookstar_app/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookstarRouter {
  static final GlobalKey<NavigatorState> rootNavkey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeNavkey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> searchNavkey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileNavkey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    initialLocation: SplashScreen.routePath,
    navigatorKey: rootNavkey,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BaseScreen(
            state: state,
            child: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavkey,
            routes: [
              GoRoute(
                path: HomePage.routePath,
                name: HomePage.routeName,
                builder: (context, state) => BlocProvider(
                  create: (context) => PheedCubit(),
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: searchNavkey,
            routes: [
              GoRoute(
                path: SearchPage.routePath,
                name: SearchPage.routeName,
                builder: (context, state) => BlocProvider(
                  create: (context) => SearchCubit(),
                  child: SearchPage(),
                ),
                routes: [
                  GoRoute(
                    path: AladinBookScreen.routePath,
                    name: AladinBookScreen.routeName,
                    builder: (context, state) {
                      Map<String, dynamic> extra =
                          state.extra as Map<String, dynamic>? ?? {};
                      return BlocProvider(
                        create: (context) => SingleBookCubit(),
                        child: AladinBookScreen(id: extra['id'] as int),
                      );
                    },
                    routes: [],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavkey,
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                builder: (context, state) => BlocProvider(
                  create: (context) => ProfileCubit(),
                  child: ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: MyFollowingPage.routePath,
                    name: MyFollowingPage.routeName,
                    builder: (context, state) => BlocProvider(
                      create: (context) => FollowingCubit(),
                      child: const MyFollowingPage(),
                    ),
                  ),
                  GoRoute(
                    path: MyFollowerPage.routePath,
                    name: MyFollowerPage.routeName,
                    builder: (context, state) => BlocProvider(
                      create: (context) => FollowerCubit(),
                      child: const MyFollowerPage(),
                    ),
                  ),
                  GoRoute(
                    path: MyReviews.routePath,
                    name: MyReviews.routeName,
                    builder: (context, state) => const MyReviews(),
                  ),
                  GoRoute(
                    path: MyScraps.routePath,
                    name: MyScraps.routeName,
                    builder: (context, state) => const MyScraps(),
                  ),
                  GoRoute(
                    path: MyCollectionPage.routePath,
                    name: MyCollectionPage.routeName,
                    builder: (context, state) => BlocProvider(
                      create: (context) => CollectionCubit(),
                      child: const MyCollectionPage(),
                    ),
                  ),
                  GoRoute(
                    path: MyLibrary.routePath,
                    name: MyLibrary.routeName,
                    builder: (context, state) => const MyLibrary(),
                  ),
                  GoRoute(
                    path: ElseProfilePage.routePath,
                    name: ElseProfilePage.routeName,
                    builder: (context, state) {
                      Map<String, dynamic> extra =
                          state.extra as Map<String, dynamic>? ?? {};
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => ProfileCubit(),
                          ),
                          BlocProvider(
                            create: (context) => FollowingCubit(),
                          ),
                          BlocProvider(
                            create: (context) => FollowerCubit(),
                          ),
                        ],
                        child: ElseProfilePage(
                          memberId: extra['memberId'] as int,
                          isFollowing: extra['isFollowing'] as bool,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                          path: ElseFollowerPage.routePath,
                          name: ElseFollowerPage.routeName,
                          builder: (context, state) {
                            Map<String, dynamic> extra =
                                state.extra as Map<String, dynamic>? ?? {};
                            return BlocProvider(
                              create: (context) => FollowerCubit(),
                              child: ElseFollowerPage(
                                memberId: extra['memberId'] as int,
                              ),
                            );
                          }),
                      GoRoute(
                          path: ElseFollowingPage.routePath,
                          name: ElseFollowingPage.routeName,
                          builder: (context, state) {
                            Map<String, dynamic> extra =
                                state.extra as Map<String, dynamic>? ?? {};
                            return BlocProvider(
                              create: (context) => FollowingCubit(),
                              child: ElseFollowingPage(
                                memberId: extra['memberId'] as int,
                              ),
                            );
                          }),
                    ],
                  ),
                  GoRoute(
                      path: MyFeedPage.routePath,
                      name: MyFeedPage.routeName,
                      builder: (context, state) {
                        Map<String, dynamic> extra =
                            state.extra as Map<String, dynamic>? ?? {};
                        return BlocProvider(
                          create: (context) => SingleBookCubit(),
                          child: MyFeedPage(
                            id: extra['id'] as int,
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
