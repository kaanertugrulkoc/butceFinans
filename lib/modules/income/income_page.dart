import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'income_controller.dart';
import '../../widgets/transaction_list.dart';

class IncomePage extends GetView<IncomeController> {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelirler'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return TransactionList(
          transactions: controller.incomes,
          isIncome: true,
          onDelete: (id) => controller.deleteIncome(id),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddIncomeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
