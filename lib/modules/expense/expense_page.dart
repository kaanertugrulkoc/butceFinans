import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expense_controller.dart';

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
        return ListView.builder(
          itemCount: controller.expenses.length,
          itemBuilder: (context, index) {
            final expense = controller.expenses[index];

            // Null kontrolü ve tip dönüşümü
            final amount = (expense['amount'] ?? 0.0) as double;
            final description = expense['description']?.toString() ?? '';
            final date = expense['date']?.toString() ?? '';
            final category = expense['category']?.toString() ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.money_off,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '${amount.toStringAsFixed(2)}₺',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (description.isNotEmpty) Text(description),
                    Text(
                      'Kategori: $category',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (date.isNotEmpty)
                      Text(
                        controller.formatDate(date),
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
