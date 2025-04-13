import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class BalanceCard extends GetView<TransactionsController> {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Bakiye',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  '₺${(controller.totalIncome.value - controller.totalExpense.value).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
