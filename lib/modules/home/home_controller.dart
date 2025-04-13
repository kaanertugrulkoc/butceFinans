import 'package:get/get.dart';
import 'package:bitirme_projesi_app/services/database_service.dart';

class HomeController extends GetxController {
  final DatabaseService databaseService = Get.find<DatabaseService>();

  final RxBool isLoading = false.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final expensesByCategory = <Map<String, dynamic>>[].obs;
  final incomesByCategory = <Map<String, dynamic>>[].obs;
  final selectedCategoryTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTotals();
  }

  @override
  void onReady() {
    super.onReady();
    // Gelir veya gider eklendiğinde verileri güncelle
    ever(totalIncome, (_) => loadTotals());
    ever(totalExpense, (_) => loadTotals());
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadTotals() async {
    try {
      isLoading.value = true;

      final incomeTotal = await databaseService.getTotalIncome();
      final expenseTotal = await databaseService.getTotalExpense();

      totalIncome.value = incomeTotal ?? 0.0;
      totalExpense.value = expenseTotal ?? 0.0;
      balance.value = totalIncome.value - totalExpense.value;

      // Kategori bazlı verileri yükle
      final expenses = await databaseService.getExpensesByCategory();
      final incomes = await databaseService.getIncomesByCategory();

      expensesByCategory.value = expenses;
      incomesByCategory.value = incomes;
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Toplamlar yüklenirken bir hata oluştu',
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
    loadTotals();
  }

  void onExpenseAdded() {
    loadTotals();
  }
}
