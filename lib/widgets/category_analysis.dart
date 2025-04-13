import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class CategoryAnalysis extends StatelessWidget {
  const CategoryAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Card(
      margin: const EdgeInsets.all(16),
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
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final transactions = controller.transactions;
              final categoryTotals = <String, double>{};

              for (final transaction in transactions) {
                final category = transaction['category'] as String;
                final amount = transaction['amount'] as double;
                final type = transaction['type'] as String;

                if (type == 'expense') {
                  categoryTotals[category] =
                      (categoryTotals[category] ?? 0) + amount;
                }
              }

              if (categoryTotals.isEmpty) {
                return const Center(
                  child: Text('Henüz gider kategorisi bulunmuyor'),
                );
              }

              final totalExpense =
                  categoryTotals.values.reduce((a, b) => a + b);

              return Column(
                children: categoryTotals.entries.map((entry) {
                  final percentage =
                      (entry.value / totalExpense * 100).toStringAsFixed(1);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(entry.key),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearProgressIndicator(
                            value: entry.value / totalExpense,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₺${entry.value.toStringAsFixed(2)} ($percentage%)',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
