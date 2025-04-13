import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class TransactionList extends GetView<TransactionsController> {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final transactions = controller.transactions;

      if (transactions.isEmpty) {
        return const Center(
          child: Text('Henüz işlem bulunmuyor'),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length > 5 ? 5 : transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isIncome = transaction['type'] == 'income';
          final color = isIncome ? Colors.green : Colors.red;
          final icon = isIncome ? Icons.add_circle : Icons.remove_circle;

          return Card(
            child: ListTile(
              leading: Icon(icon, color: color),
              title: Text(transaction['category'] as String),
              subtitle:
                  Text(controller.formatDate(transaction['date'] as String)),
              trailing: Text(
                '₺${(transaction['amount'] as num).toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
