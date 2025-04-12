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
  final categories = ['Yemek', 'Ulaşım', 'Faturalar', 'Alışveriş', 'Diğer'].obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
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

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
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
