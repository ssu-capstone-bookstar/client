import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:bookstar_app/pages/base_screen.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
import 'package:bookstar_app/pages/home/state/pheed_cubit/pheed_cubit.dart';
import 'package:bookstar_app/pages/my_page/screen/my_follower_page.dart';
import 'package:bookstar_app/pages/my_page/screen/my_following_page.dart';
import 'package:bookstar_app/pages/my_page/screen/profile_page.dart';
import 'package:bookstar_app/pages/my_page/state/follower_cubit/follower_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/following_cubit/following_cubit.dart';
import 'package:bookstar_app/pages/my_page/state/profile_cubit/profile_cubit.dart';
import 'package:bookstar_app/pages/search/SearchPage.dart';
import 'package:bookstar_app/pages/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookstarRouter {
  static GoRouter router = GoRouter(
    initialLocation: SplashScreen.routePath,
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
            routes: [
              GoRoute(
                path: SearchPage.routePath,
                name: SearchPage.routeName,
                builder: (context, state) => SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
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
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
