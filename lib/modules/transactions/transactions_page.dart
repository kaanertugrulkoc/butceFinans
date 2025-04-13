import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transactions_controller.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlemlerim'),
      ),
      body: GetBuilder<TransactionsController>(
        init: TransactionsController(),
        builder: (controller) {
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
                final date = DateTime.parse(transaction['date'] as String);
                final formattedDate = '${date.day}/${date.month}/${date.year}';

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
                      transaction['id'] as int,
                      transaction['type'] as String,
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction['color'] as Color,
                        child: Icon(
                          transaction['type'] == 'income'
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(transaction['category'] as String),
                      subtitle: Text(formattedDate),
                      trailing: Text(
                        '₺${(transaction['amount'] as num).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction['color'] as Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
