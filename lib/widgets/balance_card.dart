import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class BalanceCard extends GetView<TransactionsController> {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>(tag: 'transactions');

    return Obx(() {
      final totalIncome = controller.totalIncome?.value ?? 0.0;
      final totalExpense = controller.totalExpense?.value ?? 0.0;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                  'Bakiye: ₺${(totalIncome - totalExpense).toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Gelir: ₺$totalIncome',
                  style: TextStyle(color: Colors.green)),
              Text('Gider: ₺$totalExpense',
                  style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    });
  }
}
