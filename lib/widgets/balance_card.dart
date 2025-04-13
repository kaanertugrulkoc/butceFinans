import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class BalanceCard extends GetView<TransactionsController> {
  const BalanceCard({Key? key}) : super(key: key);

  TransactionsController get _controller {
    try {
      return Get.find<TransactionsController>();
    } catch (e) {
      Get.put(TransactionsController(), permanent: true);
      return Get.find<TransactionsController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalIncome = _controller.totalIncome.value;
      final totalExpense = _controller.totalExpense.value;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                  'Bakiye: ₺${(totalIncome - totalExpense).toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text(' Gelir: ₺$totalIncome',
                  style: TextStyle(color: Colors.green)),
              Text(' Gider: ₺$totalExpense',
                  style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    });
  }
}
