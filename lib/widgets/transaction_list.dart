import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.transactions.isEmpty) {
        return const Center(
          child: Text('Henüz işlem bulunmuyor'),
        );
      }

      return ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          final isIncome = transaction['type'] == 'income';
          final color = isIncome ? Colors.green : Colors.red;
          final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

          return Dismissible(
            key: Key(transaction['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              controller.deleteTransaction(
                transaction['id'],
                transaction['type'],
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color),
              ),
              title: Text(transaction['description'] ?? ''),
              subtitle: Text(
                '${transaction['category']} - ${controller.formatDate(transaction['date'])}',
              ),
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
