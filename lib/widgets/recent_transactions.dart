import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

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
              'Son İşlemler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.incomes.isEmpty && controller.expenses.isEmpty) {
                return const Center(
                  child: Text('Henüz işlem bulunmuyor'),
                );
              }

              // Son 5 işlemi birleştir ve tarihe göre sırala
              final allTransactions = [
                ...controller.incomes.map((e) => {...e, 'type': 'income'}),
                ...controller.expenses.map((e) => {...e, 'type': 'expense'}),
              ]..sort((a, b) => DateTime.parse(b['date'] as String)
                  .compareTo(DateTime.parse(a['date'] as String)));

              final recentTransactions = allTransactions.take(5).toList();

              return Column(
                children: recentTransactions.map((transaction) {
                  final isIncome = transaction['type'] == 'income';
                  final amount = transaction['amount'] as double? ?? 0.0;
                  final description =
                      transaction['description'] as String? ?? '';
                  final category =
                      transaction['category'] as String? ?? 'Kategorisiz';
                  final date = DateTime.parse(transaction['date'] as String? ??
                      DateTime.now().toIso8601String());

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green : Colors.red,
                      child: Icon(
                        isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '₺${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description.isNotEmpty) Text(description),
                        Text('Kategori: $category'),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: const TextStyle(fontSize: 12),
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
