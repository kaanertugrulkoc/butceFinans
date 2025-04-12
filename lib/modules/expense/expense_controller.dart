import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class ExpenseController extends GetxController {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final databaseService = DatabaseService();

  final expenses = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final totalExpense = 0.0.obs;
  final categories = [
    'Kira',
    'Faturalar',
    'Market',
    'Ulaşım',
    'Sağlık',
    'Eğlence',
    'Diğer',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  Future<void> loadExpenses() async {
    isLoading.value = true;
    try {
      final data = await databaseService.getExpenses();
      expenses.value = data;
      totalExpense.value = await databaseService.getTotalExpense();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense() async {
    if (amountController.text.isNotEmpty &&
        categoryController.text.isNotEmpty) {
      final expense = {
        'amount': double.parse(amountController.text),
        'description': descriptionController.text,
        'category': categoryController.text,
        'date': DateTime.now().toString().split(' ')[0],
      };

      await databaseService.insertExpense(expense);

      // Form temizleme
      amountController.clear();
      descriptionController.clear();
      categoryController.clear();

      // Listeyi güncelle
      await loadExpenses();
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> deleteExpense(int id) async {
    try {
      await databaseService.deleteExpense(id);
      await loadExpenses();
      Get.snackbar(
        'Başarılı',
        'Gider başarıyla silindi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gider silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showAddExpenseDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final categories = [
      'Kira',
      'Faturalar',
      'Market',
      'Ulaşım',
      'Sağlık',
      'Eğlence',
      'Diğer',
    ];

    Get.dialog(
      AlertDialog(
        title: const Text('Yeni Gider Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
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
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  categoryController.text = newValue;
                }
              },
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
              if (amountController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                await databaseService.insertExpense({
                  'amount': double.parse(amountController.text),
                  'description': descriptionController.text,
                  'category': categoryController.text,
                  'date': DateTime.now().toIso8601String(),
                });
                await loadExpenses();
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

class Expense {
  final double amount;
  final String description;
  final String category;
  final String date;

  Expense({
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });
}
