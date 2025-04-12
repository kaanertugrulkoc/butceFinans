import 'package:get/get.dart';
import '../../services/database_service.dart';

class HomeController extends GetxController {
  final databaseService = DatabaseService();

  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final isLoading = false.obs;
  final expensesByCategory = <Map<String, dynamic>>[].obs;
  final incomesByCategory = <Map<String, dynamic>>[].obs;
  final selectedCategoryTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    // Gelir veya gider eklendiğinde verileri güncelle
    ever(totalIncome, (_) => loadData());
    ever(totalExpense, (_) => loadData());
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      totalIncome.value = await databaseService.getTotalIncome();
      totalExpense.value = await databaseService.getTotalExpense();
      expensesByCategory.value = await databaseService.getExpensesByCategory();
      incomesByCategory.value = await databaseService.getIncomesByCategory();
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

  void changeCategoryTab(int index) {
    selectedCategoryTab.value = index;
  }

  void onIncomeAdded() {
    loadData();
  }

  void onExpenseAdded() {
    loadData();
  }
}
