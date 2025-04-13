import 'package:bitirme_projesi_app/modules/home/home_binding.dart';
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
import '../modules/category_analysis/category_analysis_page.dart';
import '../modules/category_analysis/category_analysis_binding.dart';

part 'app_routes.dart';

abstract class AppRouters {
  static const INITIAL = Routes.HOME;
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const INCOME = '/income';
  static const EXPENSE = '/expense';
  static const TRANSACTIONS = '/transactions';
  static const CATEGORY_ANALYSIS = '/category_analysis';
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final List<GetPage> pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.INCOME,
      page: () => const IncomePage(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.EXPENSE,
      page: () => const ExpensePage(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: Routes.TRANSACTIONS,
      page: () => const TransactionsPage(),
      binding: TransactionsBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY_ANALYSIS,
      page: () => const CategoryAnalysisPage(),
      binding: CategoryAnalysisBinding(),
    ),
  ];
}
