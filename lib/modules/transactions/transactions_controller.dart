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

      allTransactions.sort((a, b) {
        final dateA = DateTime.parse(a['date'] as String);
        final dateB = DateTime.parse(b['date'] as String);
        return dateB.compareTo(dateA);
      });

      transactions.value = allTransactions;
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
}
