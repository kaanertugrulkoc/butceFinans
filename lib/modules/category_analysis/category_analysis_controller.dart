import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/currency_service.dart';

class CategoryAnalysisController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DatabaseService databaseService = Get.find<DatabaseService>();
  final CurrencyService currencyService = CurrencyService();

  late TabController tabController;
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> incomesByCategory =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> expensesByCategory =
      <Map<String, dynamic>>[].obs;
  final RxDouble usdRate = 0.0.obs;
  final RxDouble eurRate = 0.0.obs;
  final RxDouble goldRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    loadData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadCategoryData(),
        loadCurrencyData(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Veriler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategoryData() async {
    final expenses = await databaseService.getExpensesByCategory();
    final incomes = await databaseService.getIncomesByCategory();
    expensesByCategory.value = expenses;
    incomesByCategory.value = incomes;
  }

  Future<void> loadCurrencyData() async {
    try {
      final currencyRates = await currencyService.getCurrencyRates();
      final goldPrice = await currencyService.getGoldPrice();

      usdRate.value = currencyRates['usd'] ?? 0.0;
      eurRate.value = currencyRates['eur'] ?? 0.0;
      goldRate.value = goldPrice;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Döviz kurları yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
