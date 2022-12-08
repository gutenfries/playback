import 'package:playback/screens/auth/auth.dart';
import 'package:playback/screens/home/home.dart';
import 'package:playback/screens/me/cards/cards_screen.dart';
import 'package:playback/screens/screens.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
      children: [
        GetPage(name: Routes.register, page: () => RegisterScreen()),
        GetPage(name: Routes.login, page: () => LoginScreen()),
      ],
    ),
    GetPage(
        name: Routes.home,
        page: () => const HomeScreen(),
        binding: HomeBinding(),
        children: [
          GetPage(name: Routes.cards, page: () => const CardsScreen()),
        ]),
  ];
}
