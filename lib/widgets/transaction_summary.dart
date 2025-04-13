import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class TransactionSummary extends StatelessWidget {
  const TransactionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    final incomes =
        controller.transactions.where((t) => t['type'] == 'income').length;
    final expenses =
        controller.transactions.where((t) => t['type'] == 'expense').length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İşlem Özeti',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Gelir Sayısı',
                    incomes.toString(),
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Gider Sayısı',
                    expenses.toString(),
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
