import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class IncomeController extends GetxController {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final databaseService = DatabaseService();

  final incomes = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final totalIncome = 0.0.obs;
  final categories = [
    'Maaş',
    'Mesai',
    'Yatırım',
    'Kira',
    'İkramiye',
    'Ek Gelir',
    'Diğer',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadIncomes();
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  Future<void> loadIncomes() async {
    isLoading.value = true;
    try {
      final data = await databaseService.getIncomes();
      incomes.value = data;
      final total = await databaseService.getTotalIncome();
      totalIncome.value = total ?? 0.0;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelirler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addIncome() async {
    if (amountController.text.isNotEmpty &&
        categoryController.text.isNotEmpty) {
      final income = {
        'amount': double.parse(amountController.text),
        'description': descriptionController.text,
        'category': categoryController.text,
        'date': DateTime.now().toString().split(' ')[0],
      };

      await databaseService.addIncome(income);

      // Form temizleme
      amountController.clear();
      descriptionController.clear();
      categoryController.clear();

      // Listeyi güncelle
      await loadIncomes();
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> deleteIncome(int id) async {
    try {
      await databaseService.deleteIncome(id);
      await loadIncomes();
      Get.snackbar(
        'Başarılı',
        'Gelir başarıyla silindi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelir silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showAddIncomeDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final categories = [
      'Maaş',
      'Mesai',
      'Yatırım',
      'Kira',
      'İkramiye',
      'Ek Gelir',
      'Diğer',
    ];

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
                await databaseService.addIncome({
                  'amount': double.parse(amountController.text),
                  'description': descriptionController.text,
                  'category': categoryController.text,
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
  final String category;
  final String date;

  Income({
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });
}
