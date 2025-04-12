import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/services/currency_service.dart';
import 'category_analysis_controller.dart';

class CategoryAnalysisPage extends StatelessWidget {
  final CategoryAnalysisController controller =
      Get.put(CategoryAnalysisController());
  final CurrencyService currencyService = CurrencyService();

  CategoryAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kategori Analizi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gelirler'),
              Tab(text: 'Giderler'),
              Tab(text: 'Döviz & Altın'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildIncomeAnalysis(),
            _buildExpenseAnalysis(),
            _buildCurrencyAndGold(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeAnalysis() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: controller.categorizedIncomes.length,
        itemBuilder: (context, index) {
          final category = controller.categorizedIncomes[index];
          return ListTile(
            title: Text(category.name),
            trailing: Text('₺${category.amount.toStringAsFixed(2)}'),
          );
        },
      );
    });
  }

  Widget _buildExpenseAnalysis() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: controller.categorizedExpenses.length,
        itemBuilder: (context, index) {
          final category = controller.categorizedExpenses[index];
          return ListTile(
            title: Text(category.name),
            trailing: Text('₺${category.amount.toStringAsFixed(2)}'),
          );
        },
      );
    });
  }

  Widget _buildCurrencyAndGold() {
    return FutureBuilder(
      future: Future.wait([
        currencyService.getCurrencyRates(),
        currencyService.getGoldPrice(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Hata: ${snapshot.error}'),
          );
        }

        final currencyRates = snapshot.data![0] as Map<String, dynamic>;
        final goldPrice = snapshot.data![1] as double;

        return ListView(
          children: [
            ListTile(
              title: const Text('Dolar (USD)'),
              trailing: Text('₺${currencyRates['usd'].toStringAsFixed(2)}'),
            ),
            ListTile(
              title: const Text('Euro (EUR)'),
              trailing: Text('₺${currencyRates['eur'].toStringAsFixed(2)}'),
            ),
            ListTile(
              title: const Text('Gram Altın'),
              trailing: Text('₺${goldPrice.toStringAsFixed(2)}'),
            ),
          ],
        );
      },
    );
  }
}
