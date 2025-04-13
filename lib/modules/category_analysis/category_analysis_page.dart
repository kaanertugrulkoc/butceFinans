import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/services/currency_service.dart';
import 'category_analysis_controller.dart';

class CategoryAnalysisPage extends StatelessWidget {
  final CategoryAnalysisController controller =
      Get.put(CategoryAnalysisController());
  final CurrencyService currencyService = CurrencyService();

  CategoryAnalysisPage({super.key}) {
    // Sayfa açıldığında verileri yenile
    controller.refreshData();
  }

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
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _buildIncomeAnalysis(),
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _buildExpenseAnalysis(),
            ),
            _buildCurrencyAndGold(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeAnalysis() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Gelirler yükleniyor...'),
            ],
          ),
        );
      }

      final totalIncome = controller.categorizedIncomes.fold<double>(
        0,
        (sum, category) => sum + category.amount,
      );

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalCard(
              'Toplam Gelir',
              totalIncome,
              Icons.arrow_upward,
              Colors.green,
            ),
            const SizedBox(height: 16),
            ...controller.categorizedIncomes.map((category) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildCategoryCard(
                    category.name,
                    category.amount,
                    _getCategoryIcon(category.name),
                    _getCategoryColor(category.name),
                    (category.amount / totalIncome) * 100,
                  ),
                )),
          ],
        ),
      );
    });
  }

  Widget _buildExpenseAnalysis() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Giderler yükleniyor...'),
            ],
          ),
        );
      }

      final totalExpense = controller.categorizedExpenses.fold<double>(
        0,
        (sum, category) => sum + category.amount,
      );

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalCard(
              'Toplam Gider',
              totalExpense,
              Icons.arrow_downward,
              Colors.red,
            ),
            const SizedBox(height: 16),
            ...controller.categorizedExpenses.map((category) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildCategoryCard(
                    category.name,
                    category.amount,
                    _getCategoryIcon(category.name),
                    _getCategoryColor(category.name),
                    (category.amount / totalExpense) * 100,
                  ),
                )),
          ],
        ),
      );
    });
  }

  Widget _buildTotalCard(
      String title, double amount, IconData icon, Color color) {
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₺${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
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

  Widget _buildCategoryCard(
    String name,
    double amount,
    IconData icon,
    Color color,
    double percentage,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₺${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '%${percentage.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'maaş':
        return Icons.work;
      case 'mesai':
        return Icons.timer;
      case 'yatırım':
        return Icons.trending_up;
      case 'kira':
        return Icons.home;
      case 'faturalar':
        return Icons.receipt;
      case 'market':
        return Icons.shopping_cart;
      case 'ulaşım':
        return Icons.directions_car;
      case 'sağlık':
        return Icons.local_hospital;
      case 'eğlence':
        return Icons.celebration;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'maaş':
        return Colors.blue;
      case 'mesai':
        return Colors.orange;
      case 'yatırım':
        return Colors.green;
      case 'kira':
        return Colors.purple;
      case 'faturalar':
        return Colors.red;
      case 'market':
        return Colors.amber;
      case 'ulaşım':
        return Colors.teal;
      case 'sağlık':
        return Colors.pink;
      case 'eğlence':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
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
