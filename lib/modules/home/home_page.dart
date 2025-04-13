import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bitirme_projesi_app/modules/income/income_page.dart';
import 'package:bitirme_projesi_app/modules/expense/expense_page.dart';
import 'package:bitirme_projesi_app/modules/category_analysis/category_analysis_page.dart';
import 'home_controller.dart';
import '../profile/profile_page.dart';
import '../about/about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    // Controller'ı manuel olarak kaydet
    if (!Get.isRegistered<HomeController>()) {
      controller = Get.put(HomeController());
    } else {
      controller = Get.find<HomeController>();
    }
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.to(() => const ProfilePage()),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Get.to(() => const AboutPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuGrid(),
                const SizedBox(height: 10),
                _buildSummaryCard(controller),
                const SizedBox(height: 5),
                _buildPieChart(controller),
                const SizedBox(height: 5),
                _buildCategoryTabs(controller),
              ],
            ),
          ),
        );
      }),
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
                  controller.selectedCategoryTab.value == 0,
                  () => controller.changeCategoryTab(0),
                ),
                _buildCategoryTab(
                  'Giderler',
                  Icons.money_off,
                  Colors.red,
                  controller.selectedCategoryTab.value == 1,
                  () => controller.changeCategoryTab(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.selectedCategoryTab.value == 0) {
                return _buildIncomeCategories(controller);
              } else {
                return _buildExpenseCategories(controller);
              }
            }),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hızlı İşlemler',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.5,
              children: [
                _buildMenuButton(
                  'Gelir Ekle',
                  Icons.add_circle_outline,
                  Colors.green,
                  () => Get.to(() => const IncomePage()),
                ),
                _buildMenuButton(
                  'Gider Ekle',
                  Icons.remove_circle_outline,
                  Colors.red,
                  () => Get.to(() => const ExpensePage()),
                ),
                _buildMenuButton(
                  'Varlıklarım',
                  Icons.analytics_outlined,
                  Colors.blue,
                  () => Get.to(() => const CategoryAnalysisPage()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
