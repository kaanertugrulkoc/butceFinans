import 'package:bitirme_projesi_app/core/base_controller.dart';
import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  @override
  void onReady() {
    super.onReady();
    Get.find<StorageService>().getAllValues();
  }
}
