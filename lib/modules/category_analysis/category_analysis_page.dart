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
          title: const Text('Varlıklarım'),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Veriler yüklenirken bir hata oluştu:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Sayfayı yeniden yükle
                    Get.off(() => CategoryAnalysisPage());
                  },
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final currencyRates = snapshot.data![0] as Map<String, dynamic>;
        final goldPrice = snapshot.data![1] as double;

        return RefreshIndicator(
          onRefresh: () async {
            // Sayfayı yeniden yükle
            Get.off(() => CategoryAnalysisPage());
          },
          child: ListView(
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
          ),
        );
      },
    );
  }
}
