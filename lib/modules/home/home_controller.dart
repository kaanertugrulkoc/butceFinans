import 'package:get/get.dart';
import '../../services/database_service.dart';

class HomeController extends GetxController {
  final databaseService = DatabaseService();

  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final isLoading = false.obs;
  final last30DaysData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    // Her 5 saniyede bir verileri güncelle
    Future.delayed(const Duration(seconds: 5), () {
      loadData();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Toplam gelir ve gideri güncelle
      totalIncome.value = await databaseService.getTotalIncome();
      totalExpense.value = await databaseService.getTotalExpense();
      last30DaysData.value = await databaseService.getLast30DaysData();
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

  // Gelir eklendiğinde çağrılacak
  void onIncomeAdded() {
    loadData();
  }

  // Gider eklendiğinde çağrılacak
  void onExpenseAdded() {
    loadData();
  }
}
