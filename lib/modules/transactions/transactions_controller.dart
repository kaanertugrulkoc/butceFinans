import 'package:get/get.dart';
import 'package:bitirme_projesi_app/services/database_service.dart';
import 'package:flutter/material.dart';

class TransactionsController extends GetxController {
  final DatabaseService databaseService = Get.find<DatabaseService>();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> transactions =
      <Map<String, dynamic>>[].obs;
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;

      final incomes = await databaseService.getIncomes();
      final expenses = await databaseService.getExpenses();

      final allTransactions = [
        ...incomes.map((income) => {
              ...income,
              'type': 'income',
              'color': Colors.green,
            }),
        ...expenses.map((expense) => {
              ...expense,
              'type': 'expense',
              'color': Colors.red,
            }),
      ];

      // Filter transactions by selected month and year
      final filteredTransactions = allTransactions.where((transaction) {
        final date = DateTime.parse(transaction['date'] as String);
        return date.month == selectedMonth.value &&
            date.year == selectedYear.value;
      }).toList();

      filteredTransactions.sort((a, b) {
        final dateA = DateTime.parse(a['date'] as String);
        final dateB = DateTime.parse(b['date'] as String);
        return dateB.compareTo(dateA);
      });

      transactions.value = filteredTransactions;

      // Update totals
      final incomeTotal = await databaseService.getTotalIncome();
      final expenseTotal = await databaseService.getTotalExpense();
      totalIncome.value = incomeTotal ?? 0.0;
      totalExpense.value = expenseTotal ?? 0.0;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'İşlemler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedMonth(int month) {
    selectedMonth.value = month;
    loadTransactions();
  }

  void updateSelectedYear(int year) {
    selectedYear.value = year;
    loadTransactions();
  }

  Future<void> deleteTransaction(int id, String type) async {
    try {
      if (type == 'income') {
        await databaseService.deleteIncome(id);
      } else {
        await databaseService.deleteExpense(id);
      }

      await loadTransactions();

      Get.snackbar(
        'Başarılı',
        'İşlem başarıyla silindi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'İşlem silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    try {
      await databaseService.addIncome(income);
      await loadTransactions();
      Get.snackbar(
        'Başarılı',
        'Gelir başarıyla eklendi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelir eklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    try {
      await databaseService.addExpense(expense);
      await loadTransactions();
      Get.snackbar(
        'Başarılı',
        'Gider başarıyla eklendi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gider eklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
