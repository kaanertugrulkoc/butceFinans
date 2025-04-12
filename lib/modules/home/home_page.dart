import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
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
                  _buildSummaryCard(controller),
                  const SizedBox(height: 24),
                  _buildPieChart(controller),
                  const SizedBox(height: 24),
                  _buildCategoryTabs(controller),
                  const SizedBox(height: 24),
                  _buildMenuGrid(),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSummaryCard(HomeController controller) {
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

  Widget _buildPieChart(HomeController controller) {
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
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: controller.totalIncome.value,
                      title:
                          'Gelir\n${((controller.totalIncome.value / total) * 100).toStringAsFixed(1)}%\n${controller.totalIncome.value.toStringAsFixed(2)}₺',
                      color: Colors.green,
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    PieChartSectionData(
                      value: controller.totalExpense.value,
                      title:
                          'Gider\n${((controller.totalExpense.value / total) * 100).toStringAsFixed(1)}%\n${controller.totalExpense.value.toStringAsFixed(2)}₺',
                      color: Colors.red,
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
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

  Widget _buildCategoryTabs(HomeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori Analizi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryTab(
                  'Gelirler',
                  Icons.attach_money,
                  Colors.green,
                  controller.selectedCategoryTab == 0,
                  () => controller.changeCategoryTab(0),
                ),
                _buildCategoryTab(
                  'Giderler',
                  Icons.money_off,
                  Colors.red,
                  controller.selectedCategoryTab == 1,
                  () => controller.changeCategoryTab(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.selectedCategoryTab == 0)
              _buildIncomeCategories(controller)
            else
              _buildExpenseCategories(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(
    String title,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCategories(HomeController controller) {
    if (controller.incomesByCategory.isEmpty) {
      return const Center(
        child: Text(
          'Henüz kategori bazlı gelir bulunmuyor',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.incomesByCategory.length,
      itemBuilder: (context, index) {
        final category = controller.incomesByCategory[index];
        final total = category['total'] as double;
        final percentage = (total / controller.totalIncome.value) * 100;

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
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.green.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseCategories(HomeController controller) {
    if (controller.expensesByCategory.isEmpty) {
      return const Center(
        child: Text(
          'Henüz kategori bazlı gider bulunmuyor',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.expensesByCategory.length,
      itemBuilder: (context, index) {
        final category = controller.expensesByCategory[index];
        final total = category['total'] as double;
        final percentage = (total / controller.totalExpense.value) * 100;

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
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuGrid() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMenuButton(
              'Gelir Ekle',
              Icons.attach_money,
              Colors.green,
              '/income',
            ),
            _buildMenuButton(
              'Gider Ekle',
              Icons.money_off,
              Colors.red,
              '/expense',
            ),
            _buildMenuButton(
              'İşlem Geçmişi',
              Icons.history,
              Colors.blue,
              '/transactions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
