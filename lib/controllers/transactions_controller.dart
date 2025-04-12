import 'package:get/get.dart';
import '../services/database_service.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class TransactionsController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Gelir ve gider listeleri
  final RxList<Map<String, dynamic>> incomes = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> expenses = <Map<String, dynamic>>[].obs;

  // Kategori bazlı analizler
  final RxList<Category> incomeCategories = <Category>[].obs;
  final RxList<Category> expenseCategories = <Category>[].obs;

  // Toplam değerler
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;

  // Seçili ay ve yıl
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  // Aylık özet
  final RxList<Map<String, dynamic>> monthlySummary =
      <Map<String, dynamic>>[].obs;

  // Yıllık özet
  final RxList<Map<String, dynamic>> yearlySummary =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
    loadCategoryAnalyses();
    loadMonthlySummary();
    loadYearlySummary();
  }

  Future<void> loadTransactions() async {
    try {
      final loadedIncomes = await _databaseService.getIncomes(
        month: selectedMonth.value,
        year: selectedYear.value,
      );
      final loadedExpenses = await _databaseService.getExpenses(
        month: selectedMonth.value,
        year: selectedYear.value,
      );

      incomes.value = loadedIncomes;
      expenses.value = loadedExpenses;

      totalIncome.value = await _databaseService.getTotalIncome(
        month: selectedMonth.value,
        year: selectedYear.value,
      );
      totalExpense.value = await _databaseService.getTotalExpense(
        month: selectedMonth.value,
        year: selectedYear.value,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'İşlemler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadCategoryAnalyses() async {
    try {
      final incomeCategoryData = await _databaseService.getIncomesByCategory(
        month: selectedMonth.value,
        year: selectedYear.value,
      );
      final expenseCategoryData = await _databaseService.getExpensesByCategory(
        month: selectedMonth.value,
        year: selectedYear.value,
      );

      incomeCategories.value = incomeCategoryData
          .map((data) => Category(
                name: data['category'] as String,
                amount: data['total'] as double,
              ))
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      expenseCategories.value = expenseCategoryData
          .map((data) => Category(
                name: data['category'] as String,
                amount: data['total'] as double,
              ))
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kategori analizleri yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadMonthlySummary() async {
    try {
      final summary = await _databaseService.getMonthlySummary(
        year: selectedYear.value,
      );
      monthlySummary.value = summary;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Aylık özet yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadYearlySummary() async {
    try {
      final summary = await _databaseService.getYearlySummary();
      yearlySummary.value = summary;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Yıllık özet yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void setSelectedMonth(int month) {
    selectedMonth.value = month;
    loadTransactions();
    loadCategoryAnalyses();
    loadMonthlySummary();
  }

  void setSelectedYear(int year) {
    selectedYear.value = year;
    loadTransactions();
    loadCategoryAnalyses();
    loadMonthlySummary();
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    try {
      await _databaseService.insertIncome(income);
      await loadTransactions();
      await loadCategoryAnalyses();
      Get.snackbar(
        'Başarılı',
        'Gelir başarıyla eklendi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelir eklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    try {
      await _databaseService.insertExpense(expense);
      await loadTransactions();
      await loadCategoryAnalyses();
      Get.snackbar(
        'Başarılı',
        'Gider başarıyla eklendi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gider eklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      await _databaseService.deleteIncome(id);
      await loadTransactions();
      await loadCategoryAnalyses();
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

  Future<void> deleteExpense(int id) async {
    try {
      await _databaseService.deleteExpense(id);
      await loadTransactions();
      await loadCategoryAnalyses();
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
}
