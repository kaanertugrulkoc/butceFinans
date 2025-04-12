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
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Güncel kurlar yükleniyor...'),
              ],
            ),
          );
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
                ElevatedButton.icon(
                  onPressed: () {
                    Get.off(() => CategoryAnalysisPage());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final currencyRates = snapshot.data![0] as Map<String, dynamic>;
        final goldPrice = snapshot.data![1] as double;

        return RefreshIndicator(
          onRefresh: () async {
            Get.off(() => CategoryAnalysisPage());
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildInfoCard(
                'Güncel Döviz ve Altın Kurları',
                'Son güncelleme: ${DateTime.now().hour}:${DateTime.now().minute}',
                Icons.access_time,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildCurrencyCard(
                'Amerikan Doları',
                'USD',
                currencyRates['usd'],
                Icons.attach_money,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildCurrencyCard(
                'Euro',
                'EUR',
                currencyRates['eur'],
                Icons.euro,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildCurrencyCard(
                'Gram Altın',
                'GAU',
                goldPrice,
                Icons.monetization_on,
                Colors.amber,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard(
    String name,
    String code,
    double value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    code,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₺${value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
