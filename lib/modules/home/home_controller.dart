import 'package:get/get.dart';
import '../../services/database_service.dart';

class HomeController extends GetxController {
  final DatabaseService databaseService = Get.find<DatabaseService>();

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxBool isLoading = true.obs;
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
    try {
      isLoading.value = true;

      // Toplam gelir ve gideri yükle
      final totalIncomeResult = await databaseService.getTotalIncome();
      final totalExpenseResult = await databaseService.getTotalExpense();

      totalIncome.value = totalIncomeResult ?? 0.0;
      totalExpense.value = totalExpenseResult ?? 0.0;

      // Kategori bazlı verileri yükle
      final expenses = await databaseService.getExpensesByCategory();
      final incomes = await databaseService.getIncomesByCategory();

      expensesByCategory.value = expenses;
      incomesByCategory.value = incomes;
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
