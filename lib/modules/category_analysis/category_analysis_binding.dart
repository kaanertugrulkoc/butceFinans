import 'package:get/get.dart';
import 'category_analysis_controller.dart';

class CategoryAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryAnalysisController>(() => CategoryAnalysisController());
  }
}
