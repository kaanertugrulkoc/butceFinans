import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IncomeController extends GetxController {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final incomes = <Income>[].obs;

  void addIncome() {
    if (amountController.text.isNotEmpty) {
      incomes.add(
        Income(
          amount: double.parse(amountController.text),
          description: descriptionController.text,
          date: DateTime.now().toString().split(' ')[0],
        ),
      );

      // Form temizleme
      amountController.clear();
      descriptionController.clear();
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
