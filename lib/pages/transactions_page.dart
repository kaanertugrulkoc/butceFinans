import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';
import '../widgets/category_analysis.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_form.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlemlerim'),
      ),
      body: Column(
        children: [
          const CategoryAnalysis(),
          Expanded(
            child: TransactionList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            const TransactionForm(),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
