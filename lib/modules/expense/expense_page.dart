import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expense_controller.dart';

class ExpensePage extends GetView<ExpenseController> {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giderler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gider ekleme formu
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Gider Miktarı',
                      prefixText: '₺',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                    ),
                    items: controller.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.categoryController.text = newValue;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Açıklama',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.addExpense,
                    child: const Text('Gider Ekle'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Gider listesi
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = controller.expenses[index];
                      return Card(
                        child: ListTile(
                          title: Text('₺${expense.amount}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(expense.description),
                              Text('Kategori: ${expense.category}'),
                            ],
                          ),
                          trailing: Text(expense.date),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
