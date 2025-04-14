import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routers/app_pages.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'services/currency_service.dart';
import '../controllers/income_controller.dart';
import '../controllers/expense_controller.dart';
import '../models/income.dart';
import '../models/expense.dart';
import 'pages/income_page.dart';
import 'pages/expense_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DatabaseService'i başlat ve kaydet (init() metodu olmadan)
  await Get.putAsync<DatabaseService>(() async => DatabaseService());

  // Diğer servisleri başlat
  await Get.putAsync<StorageService>(() async => StorageService().init());
  await Get.putAsync<ApiService>(() async => ApiService().init());

  // CurrencyService'i ekle
  Get.lazyPut(() => CurrencyService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FinansApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.pages,
    );
  }
}

class IncomePage extends StatelessWidget {
  final IncomeController controller = Get.put(IncomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelirler'),
      ),
      body: Obx(() {
        if (controller.incomes.isEmpty) {
          return Center(child: Text('Henüz gelir yok.'));
        }
        return ListView.builder(
          itemCount: controller.incomes.length,
          itemBuilder: (context, index) {
            final income = controller.incomes[index];
            return ListTile(
              title: Text(income.description),
              subtitle: Text('₺${income.amount.toStringAsFixed(2)}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Gelir ekleme işlemi
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ExpensePage extends StatelessWidget {
  final ExpenseController controller = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giderler'),
      ),
      body: Obx(() {
        if (controller.expenses.isEmpty) {
          return Center(child: Text('Henüz gider yok.'));
        }
        return ListView.builder(
          itemCount: controller.expenses.length,
          itemBuilder: (context, index) {
            final expense = controller.expenses[index];
            return ListTile(
              title: Text(expense.description),
              subtitle: Text('₺${expense.amount.toStringAsFixed(2)}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Gider ekleme işlemi
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class IncomeController extends GetxController {
  var incomes = <Income>[].obs;

  void addIncome(Income income) {
    incomes.add(income);
  }

  void fetchIncomes() {
    // Veritabanından gelirleri çekme işlemi
  }
}

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;

  void addExpense(Expense expense) {
    expenses.add(expense);
  }

  void fetchExpenses() {
    // Veritabanından giderleri çekme işlemi
  }
}

Widget _buildQuickActionsRow() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionButton(Icons.add, 'Gelirler', Colors.green, () {
          Get.to(IncomePage());
        }),
        _buildQuickActionButton(Icons.remove, 'Giderler', Colors.red, () {
          Get.to(ExpensePage());
        }),
      ],
    ),
  );
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.INCOME, page: () => IncomePage()),
    GetPage(name: Routes.EXPENSE, page: () => ExpensePage()),
  ];
}

abstract class Routes {
  static const HOME = '/home';
  static const INCOME = '/income';
  static const EXPENSE = '/expense';
}

class Income {
  final String description;
  final double amount;

  Income({required this.description, required this.amount});
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}
