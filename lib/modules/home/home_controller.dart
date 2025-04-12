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
    if (isLoading.value) return; // Eğer zaten yükleniyorsa tekrar yükleme

    isLoading.value = true;
    try {
      // Toplam gelir ve gideri yükle
      final totalIncomeResult = await databaseService.getTotalIncome();
      final totalExpenseResult = await databaseService.getTotalExpense();

      // Kategori bazlı verileri yükle
      final incomeCategories = await databaseService.getIncomesByCategory();
      final expenseCategories = await databaseService.getExpensesByCategory();

      // Verileri güncelle
      totalIncome.value = totalIncomeResult;
      totalExpense.value = totalExpenseResult;
      incomesByCategory.value = incomeCategories;
      expensesByCategory.value = expenseCategories;

      // Debug için verileri yazdır
      print('Toplam Gelir: ${totalIncome.value}');
      print('Toplam Gider: ${totalExpense.value}');
      print('Gelir Kategorileri: $incomeCategories');
      print('Gider Kategorileri: $expenseCategories');
    } catch (e, stackTrace) {
      print('Hata: $e');
      print('Stack Trace: $stackTrace');
      Get.snackbar(
        'Hata',
        'Veriler yüklenirken bir hata oluştu: $e',
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
