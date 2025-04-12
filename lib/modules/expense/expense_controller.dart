import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExpenseController extends GetxController {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  final expenses = <Expense>[].obs;
  final categories = ['Yemek', 'Ulaşım', 'Faturalar', 'Alışveriş', 'Diğer'].obs;

  void addExpense() {
    if (amountController.text.isNotEmpty) {
      expenses.add(
        Expense(
          amount: double.parse(amountController.text),
          description: descriptionController.text,
          category: categoryController.text,
          date: DateTime.now().toString().split(' ')[0],
        ),
      );

      // Form temizleme
      amountController.clear();
      descriptionController.clear();
      categoryController.clear();
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
