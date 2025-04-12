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
