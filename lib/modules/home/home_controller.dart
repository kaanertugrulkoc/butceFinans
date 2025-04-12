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

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      totalIncome.value = await databaseService.getTotalIncome();
      totalExpense.value = await databaseService.getTotalExpense();
      last30DaysData.value = await databaseService.getLast30DaysData();
    } finally {
      isLoading.value = false;
    }
  }
}
