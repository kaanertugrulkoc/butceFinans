import 'package:bitirme_projesi_app/modules/splash/splash_bindings.dart';
import 'package:bitirme_projesi_app/modules/splash/splash_page.dart';
import 'package:get/get.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';
import '../modules/login/login_bindings.dart';
import '../modules/login/login_page.dart';
import '../modules/income/income_binding.dart';
import '../modules/income/income_page.dart';
import '../modules/expense/expense_binding.dart';
import '../modules/expense/expense_page.dart';
import '../modules/transactions/transactions_binding.dart';
import '../modules/transactions/transactions_page.dart';

abstract class AppRouters {
  static const INITIAL = SPLASH;
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profil';
  static const INCOME = '/income';
  static const EXPENSE = '/expense';
  static const TRANSACTIONS = '/transactions';
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
      name: AppRouters.INCOME,
      page: () => const IncomePage(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: AppRouters.EXPENSE,
      page: () => const ExpensePage(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: AppRouters.TRANSACTIONS,
      page: () => const TransactionsPage(),
      binding: TransactionsBinding(),
    ),
  ];
}
