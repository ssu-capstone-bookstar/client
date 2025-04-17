import 'package:bookstar_app/pages/auth/screen/login_page.dart';
import 'package:bookstar_app/pages/base_screen.dart';
import 'package:bookstar_app/pages/home/home_page.dart';
import 'package:bookstar_app/pages/my_page/ProfilePage.dart';
import 'package:bookstar_app/pages/search/SearchPage.dart';
import 'package:bookstar_app/pages/splash_screen.dart';
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
          return BaseScreen();
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SearchPage.routePath,
                builder: (context, state) => SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                builder: (context, state) => ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
