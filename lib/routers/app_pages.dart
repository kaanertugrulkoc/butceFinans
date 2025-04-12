import 'package:bitirme_projesi_app/modules/splash/splash_bindings.dart';
import 'package:bitirme_projesi_app/modules/splash/splash_page.dart';
import 'package:get/get.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';
import '../modules/login/login_bindings.dart';
import '../modules/login/login_page.dart';
import '../modules/income/income_binding.dart';
import '../modules/income/income_page.dart';

abstract class AppRouters {
  static const INITIAL = SPLASH;
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profil';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRouters.SPLASH,
      page: () => SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRouters.LOGIN,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: AppRouters.HOME,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: '/income',
      page: () => const IncomePage(),
      binding: IncomeBinding(),
    )
  ];
}
