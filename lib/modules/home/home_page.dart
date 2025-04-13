import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/home/home_controller.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';
import 'package:bitirme_projesi_app/widgets/balance_card.dart';
import 'package:bitirme_projesi_app/widgets/income_expense_card.dart';
import 'package:bitirme_projesi_app/widgets/quick_actions.dart';
import 'package:bitirme_projesi_app/widgets/transaction_list.dart';
import 'package:bitirme_projesi_app/widgets/monthly_chart.dart';
import 'package:bitirme_projesi_app/widgets/category_chart.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadTotals,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BalanceCard(),
                const SizedBox(height: 16),
                const IncomeExpenseCard(),
                const SizedBox(height: 16),
                const QuickActions(),
                const SizedBox(height: 16),
                const Text(
                  'Aylık Gelir/Gider Grafiği',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const MonthlyChart(),
                const SizedBox(height: 16),
                const Text(
                  'Kategori Dağılımı',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const CategoryChart(),
                const SizedBox(height: 16),
                const Text(
                  'Son İşlemler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const TransactionList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
