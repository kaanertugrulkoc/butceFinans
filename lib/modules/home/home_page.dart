import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
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
              _buildSummaryCard(),
              const SizedBox(height: 24),
              _buildPieChart(),
              const SizedBox(height: 24),
              _buildCategoryList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Toplam Gelir',
                  controller.totalIncome.value,
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Toplam Gider',
                  controller.totalExpense.value,
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Net Durum',
                  controller.totalIncome.value - controller.totalExpense.value,
                  (controller.totalIncome.value -
                              controller.totalExpense.value) >=
                          0
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(2)}₺',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final total = controller.totalIncome.value + controller.totalExpense.value;
    if (total == 0) {
      return const Center(
        child: Text(
          'Henüz veri bulunmuyor',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gelir/Gider Dağılımı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: controller.totalIncome.value,
                      title:
                          '${((controller.totalIncome.value / total) * 100).toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: controller.totalExpense.value,
                      title:
                          '${((controller.totalExpense.value / total) * 100).toStringAsFixed(1)}%',
                      color: Colors.red,
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Gelir', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Gider', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildCategoryList() {
    if (controller.expensesByCategory.isEmpty) {
      return const Center(
        child: Text(
          'Henüz kategori bazlı gider bulunmuyor',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori Bazlı Giderler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.expensesByCategory.length,
              itemBuilder: (context, index) {
                final category = controller.expensesByCategory[index];
                final total = category['total'] as double;
                final percentage =
                    (total / controller.totalExpense.value) * 100;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category['category'] as String? ?? 'Kategorisiz',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${total.toStringAsFixed(2)}₺ (${percentage.toStringAsFixed(1)}%)',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
