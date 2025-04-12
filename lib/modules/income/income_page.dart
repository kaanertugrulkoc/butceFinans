import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'income_controller.dart';

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
        return ListView.builder(
          itemCount: controller.incomes.length,
          itemBuilder: (context, index) {
            final income = controller.incomes[index];

            // Null kontrolü ve tip dönüşümü
            final amount = (income['amount'] ?? 0.0) as double;
            final description = income['description']?.toString() ?? '';
            final date = income['date']?.toString() ?? '';
            final category = income['category']?.toString() ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '${amount.toStringAsFixed(2)}₺',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
        onPressed: () => controller.showAddIncomeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
