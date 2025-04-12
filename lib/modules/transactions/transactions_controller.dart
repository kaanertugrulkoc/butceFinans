import 'package:get/get.dart';
import '../../services/database_service.dart';

class TransactionsController extends GetxController {
  final databaseService = DatabaseService();

  final incomes = <Map<String, dynamic>>[].obs;
  final expenses = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedTab = 0.obs; // 0: Gelirler, 1: Giderler

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      incomes.value = await databaseService.getIncomes();
      expenses.value = await databaseService.getExpenses();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }
}
