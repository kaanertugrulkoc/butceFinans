import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class IncomeController extends GetxController {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final databaseService = DatabaseService();

  final incomes = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final totalIncome = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadIncomes();
  }

  Future<void> loadIncomes() async {
    isLoading.value = true;
    try {
      final data = await databaseService.getIncomes();
      incomes.value = data;
      totalIncome.value = await databaseService.getTotalIncome();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addIncome() async {
    if (amountController.text.isNotEmpty) {
      final income = {
        'amount': double.parse(amountController.text),
        'description': descriptionController.text,
        'date': DateTime.now().toString().split(' ')[0],
      };

      await databaseService.insertIncome(income);

      // Form temizleme
      amountController.clear();
      descriptionController.clear();

      // Listeyi güncelle
      await loadIncomes();
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }

  void showAddIncomeDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Yeni Gelir Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gelir Miktarı',
                prefixText: '₺',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty) {
                await databaseService.insertIncome({
                  'amount': double.parse(amountController.text),
                  'description': descriptionController.text,
                  'date': DateTime.now().toIso8601String(),
                });
                await loadIncomes();
                Get.back();
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class Income {
  final double amount;
  final String description;
  final String date;

  Income({
    required this.amount,
    required this.description,
    required this.date,
  });
}
