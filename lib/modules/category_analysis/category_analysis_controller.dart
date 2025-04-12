import 'package:get/get.dart';
import '../../services/database_service.dart';
import '../../models/category.dart';

class CategoryAnalysisController extends GetxController {
  final databaseService = DatabaseService();
  final isLoading = false.obs;
  final categorizedIncomes = <Category>[].obs;
  final categorizedExpenses = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final incomes = await databaseService.getIncomes();
      final expenses = await databaseService.getExpenses();

      // Gelirleri kategorilere göre grupla
      final incomeMap = <String, double>{};
      for (var income in incomes) {
        final category = income['category'] as String;
        final amount = income['amount'] as double;
        incomeMap[category] = (incomeMap[category] ?? 0) + amount;
      }

      // Giderleri kategorilere göre grupla
      final expenseMap = <String, double>{};
      for (var expense in expenses) {
        final category = expense['category'] as String;
        final amount = expense['amount'] as double;
        expenseMap[category] = (expenseMap[category] ?? 0) + amount;
      }

      // Kategorileri listeye dönüştür
      categorizedIncomes.value = incomeMap.entries
          .map((e) => Category(name: e.key, amount: e.value))
          .toList();

      categorizedExpenses.value = expenseMap.entries
          .map((e) => Category(name: e.key, amount: e.value))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }
}
