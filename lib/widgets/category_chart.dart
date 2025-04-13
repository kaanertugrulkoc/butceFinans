import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class CategoryChart extends GetView<TransactionsController> {
  const CategoryChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Kategori Dağılımı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Obx(() {
                final transactions = controller.transactions;
                final categoryData = _calculateCategoryData(transactions);

                return PieChart(
                  PieChartData(
                    sections: categoryData.map((data) {
                      return PieChartSectionData(
                        color: data.color,
                        value: data.amount,
                        title:
                            '${(data.amount / categoryData.fold(0, (sum, item) => sum + item.amount) * 100).toStringAsFixed(1)}%',
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<CategoryData> _calculateCategoryData(
      List<Map<String, dynamic>> transactions) {
    final categoryMap = <String, double>{};
    final colorMap = <String, Color>{};

    for (final transaction in transactions) {
      final category = transaction['category'] as String;
      final amount = (transaction['amount'] as num).toDouble();
      final type = transaction['type'] as String;

      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
      colorMap[category] = type == 'income' ? Colors.green : Colors.red;
    }

    return categoryMap.entries.map((entry) {
      return CategoryData(
        category: entry.key,
        amount: entry.value,
        color: colorMap[entry.key] ?? Colors.grey,
      );
    }).toList();
  }
}

class CategoryData {
  final String category;
  final double amount;
  final Color color;

  CategoryData({
    required this.category,
    required this.amount,
    required this.color,
  });
}
