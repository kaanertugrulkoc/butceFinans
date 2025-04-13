import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FinansApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
        ],
      ),
      body: Column(
        children: [
          // Özet kartları
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Toplam Gelir',
                    '₺${controller.totalIncome.toStringAsFixed(2)}',
                    Colors.green,
                    Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Toplam Gider',
                    '₺${controller.totalExpense.toStringAsFixed(2)}',
                    Colors.red,
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ),
          // Menü grid'i
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuCard(
                  'Gelir Ekle',
                  Icons.add_circle,
                  Colors.green,
                  () => Get.toNamed(Routes.INCOME),
                ),
                _buildMenuCard(
                  'Gider Ekle',
                  Icons.remove_circle,
                  Colors.red,
                  () => Get.toNamed(Routes.EXPENSE),
                ),
                _buildMenuCard(
                  'İşlemlerim',
                  Icons.history,
                  Colors.blue,
                  () => Get.toNamed(Routes.TRANSACTIONS),
                ),
                _buildMenuCard(
                  'Varlıklarım',
                  Icons.analytics,
                  Colors.purple,
                  () => Get.toNamed(Routes.CATEGORY_ANALYSIS),
                ),
                _buildMenuCard(
                  'Hakkında',
                  Icons.info,
                  Colors.orange,
                  () => Get.toNamed(Routes.ABOUT),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
