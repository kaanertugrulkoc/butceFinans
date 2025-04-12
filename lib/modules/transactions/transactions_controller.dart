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

  void changeTab(int index) {
    selectedTab.value = index;
  }

  String formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> deleteIncome(int id) async {
    try {
      await databaseService.deleteIncome(id);
      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gelir silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await databaseService.deleteExpense(id);
      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Gider silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
