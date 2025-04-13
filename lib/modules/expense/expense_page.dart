import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expense_controller.dart';
import '../../widgets/transaction_list.dart';

class ExpensePage extends GetView<ExpenseController> {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Manuel olarak controller'ı kaydet
    if (!Get.isRegistered<ExpenseController>()) {
      Get.put(ExpenseController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giderler'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return const TransactionList();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
