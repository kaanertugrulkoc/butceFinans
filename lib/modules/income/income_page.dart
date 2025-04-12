import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'income_controller.dart';

class IncomePage extends GetView<IncomeController> {
  const IncomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelirler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gelir ekleme formu
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Gelir Miktarı',
                      prefixText: '₺',
                    ),
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
                    onPressed: controller.addIncome,
                    child: const Text('Gelir Ekle'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Gelir listesi
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.incomes.length,
                    itemBuilder: (context, index) {
                      final income = controller.incomes[index];
                      return Card(
                        child: ListTile(
                          title: Text('₺${income.amount}'),
                          subtitle: Text(income.description),
                          trailing: Text(income.date),
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
