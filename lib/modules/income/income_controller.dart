import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class IncomeController extends GetxController {
  final databaseService = DatabaseService();

  final incomes = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final totalIncome = 0.0.obs;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedCategory = 'Maaş'.obs;

  @override
  void onInit() {
    super.onInit();
    loadIncomes();
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
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
    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Hata',
        'Lütfen miktar giriniz',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final income = {
        'amount': double.parse(amountController.text),
        'description': descriptionController.text,
        'category': selectedCategory.value,
        'date': DateTime.now().toIso8601String(),
      };

      await databaseService.insertIncome(income);
      amountController.clear();
      descriptionController.clear();
      selectedCategory.value = 'Maaş';
      loadIncomes();
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelir eklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  void showAddIncomeDialog(BuildContext context) {
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
                try {
                  await databaseService.insertIncome({
                    'amount': double.parse(amountController.text),
                    'description': descriptionController.text,
                    'date': DateTime.now().toIso8601String(),
                  });
                  await loadIncomes();
                  Get.back();
                } catch (e) {
                  Get.snackbar(
                    'Hata',
                    'Gelir eklenirken bir hata oluştu',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
