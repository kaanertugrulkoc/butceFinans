import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';
import 'package:bitirme_projesi_app/widgets/balance_card.dart';
import 'package:bitirme_projesi_app/widgets/income_expense_card.dart';
import 'package:bitirme_projesi_app/widgets/transaction_list.dart';
import 'package:bitirme_projesi_app/widgets/monthly_chart.dart';
import 'package:bitirme_projesi_app/widgets/category_chart.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinansApp'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BalanceCard(),
              const SizedBox(height: 16),
              const IncomeExpenseCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(Routes.INCOME),
                      icon: const Icon(Icons.add),
                      label: const Text('Gelir Ekle'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(Routes.EXPENSE),
                      icon: const Icon(Icons.remove),
                      label: const Text('Gider Ekle'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const MonthlyChart(),
              const SizedBox(height: 16),
              const CategoryChart(),
              const SizedBox(height: 16),
              const TransactionList(),
            ],
          ),
        );
      }),
    );
  }
}
