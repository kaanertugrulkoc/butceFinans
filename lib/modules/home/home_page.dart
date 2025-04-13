import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bitirme_projesi_app/modules/income/income_page.dart';
import 'package:bitirme_projesi_app/modules/expense/expense_page.dart';
import 'package:bitirme_projesi_app/modules/category_analysis/category_analysis_page.dart';
import 'home_controller.dart';
import '../profile/profile_page.dart';
import '../about/about_page.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 16),
              _buildIncomeExpenseCard(),
              const SizedBox(height: 16),
              _buildQuickActions(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Bakiye',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₺${controller.balance.value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Gelir',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₺${controller.totalIncome.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Gider',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₺${controller.totalExpense.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hızlı İşlemler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'Gelir Ekle',
                    Icons.add_circle_outline,
                    Colors.green,
                    () => Get.toNamed(Routes.INCOME),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionButton(
                    'Gider Ekle',
                    Icons.remove_circle_outline,
                    Colors.red,
                    () => Get.toNamed(Routes.EXPENSE),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'İşlemler',
                    Icons.history,
                    Colors.blue,
                    () => Get.toNamed(Routes.TRANSACTIONS),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionButton(
                    'Analiz',
                    Icons.analytics,
                    Colors.orange,
                    () => Get.toNamed(Routes.CATEGORY_ANALYSIS),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
