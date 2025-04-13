import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class MonthlyChart extends GetView<TransactionsController> {
  const MonthlyChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Aylık Gelir/Gider Grafiği',
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
                final monthlyData = _calculateMonthlyData(transactions);

                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: monthlyData.incomeSpots,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: monthlyData.expenseSpots,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.red.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  MonthlyData _calculateMonthlyData(List<Map<String, dynamic>> transactions) {
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];

    for (var i = 1; i <= 12; i++) {
      final monthTransactions = transactions.where((t) {
        final date = DateTime.parse(t['date'] as String);
        return date.month == i;
      }).toList();

      final income = monthTransactions
          .where((t) => t['type'] == 'income')
          .fold<double>(0, (sum, t) => sum + (t['amount'] as num).toDouble());

      final expense = monthTransactions
          .where((t) => t['type'] == 'expense')
          .fold<double>(0, (sum, t) => sum + (t['amount'] as num).toDouble());

      incomeSpots.add(FlSpot(i.toDouble(), income));
      expenseSpots.add(FlSpot(i.toDouble(), expense));
    }

    return MonthlyData(incomeSpots, expenseSpots);
  }
}

class MonthlyData {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;

  MonthlyData(this.incomeSpots, this.expenseSpots);
}
