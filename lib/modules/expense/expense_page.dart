import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expense_controller.dart';
import '../../widgets/transaction_list.dart';

class ExpensePage extends GetView<ExpenseController> {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giderler'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return TransactionList(
          transactions: controller.expenses,
          isIncome: false,
          onDelete: (id) => controller.deleteExpense(id),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
