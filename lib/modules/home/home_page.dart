import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grafik
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (controller.totalIncome.value >
                                controller.totalExpense.value
                            ? controller.totalIncome.value
                            : controller.totalExpense.value) +
                        1000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                            String text;
                            switch (value.toInt()) {
                              case 0:
                                text = 'Gelir';
                                break;
                              case 1:
                                text = 'Gider';
                                break;
                              default:
                                text = '';
                                break;
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: style),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: controller.totalIncome.value,
                            color: Colors.green,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: controller.totalExpense.value,
                            color: Colors.red,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Toplam Gelir ve Gider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalCard(
                    'Toplam Gelir',
                    controller.totalIncome.value,
                    Colors.green,
                  ),
                  _buildTotalCard(
                    'Toplam Gider',
                    controller.totalExpense.value,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Menü Kartları
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuCard(
                    context,
                    'Gelirler',
                    Icons.attach_money,
                    Colors.green,
                    '/income',
                  ),
                  _buildMenuCard(
                    context,
                    'Giderler',
                    Icons.money_off,
                    Colors.red,
                    '/expense',
                  ),
                  _buildMenuCard(
                    context,
                    'İşlem Geçmişi',
                    Icons.history,
                    Colors.blue,
                    '/transactions',
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTotalCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${amount.toStringAsFixed(2)}₺',
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
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Get.toNamed(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
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
