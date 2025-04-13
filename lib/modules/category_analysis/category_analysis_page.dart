import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/services/currency_service.dart';
import 'category_analysis_controller.dart';

class CategoryAnalysisPage extends StatelessWidget {
  const CategoryAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Varlıklarım'),
      ),
      body: GetBuilder<CategoryAnalysisController>(
        init: CategoryAnalysisController(),
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    controller: controller.tabController,
                    tabs: const [
                      Tab(text: 'Gelirler'),
                      Tab(text: 'Giderler'),
                      Tab(text: 'Döviz & Altın'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        _buildIncomeTab(controller),
                        _buildExpenseTab(controller),
                        _buildCurrencyTab(controller),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildIncomeTab(CategoryAnalysisController controller) {
    return ListView.builder(
      itemCount: controller.incomesByCategory.length,
      itemBuilder: (context, index) {
        final item = controller.incomesByCategory[index];
        return ListTile(
          title: Text(item['category'] ?? 'Diğer'),
          trailing: Text(
            '₺${(item['total'] as num).toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseTab(CategoryAnalysisController controller) {
    return ListView.builder(
      itemCount: controller.expensesByCategory.length,
      itemBuilder: (context, index) {
        final item = controller.expensesByCategory[index];
        return ListTile(
          title: Text(item['category'] ?? 'Diğer'),
          trailing: Text(
            '₺${(item['total'] as num).toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyTab(CategoryAnalysisController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadCurrencyData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCurrencyCard(
            'Dolar (USD)',
            '₺${controller.usdRate.toStringAsFixed(2)}',
            Icons.attach_money,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildCurrencyCard(
            'Euro (EUR)',
            '₺${controller.eurRate.toStringAsFixed(2)}',
            Icons.euro,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildCurrencyCard(
            'Altın (Gram)',
            '₺${controller.goldRate.toStringAsFixed(2)}',
            Icons.monetization_on,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}
