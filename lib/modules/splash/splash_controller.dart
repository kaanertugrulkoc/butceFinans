import 'package:bitirme_projesi_app/core/base_controller.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';
import 'package:bitirme_projesi_app/services/api_service.dart';
import 'package:bitirme_projesi_app/services/auth_services.dart';
import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  final areServicesReady = false.obs;

  @override
  void onInit() {
    print('Onİnit Splash controller');
    super.onInit();
  }

  void onReady() async {
    super.onReady();
    await waitForServices();
    await checkTokenAndRedirect();
    // areServicesReady.value = true;
    // var map = Get.find<StorageService>().getAllValues();
    // print(map);
  }

  Future<void> waitForServices() async {
    while (!Get.isRegistered<StorageService>() &&
        !Get.isRegistered<ApiService>() &&
        !Get.isRegistered<AuthService>()) {
      await Future.delayed(Duration(seconds: 1));
    }
    var map = Get.find<StorageService>().getAllValues();
    print(map);
  }

  Future<void> checkTokenAndRedirect() async {
    Get.offAllNamed(AppRouters.LOGIN);

  }
}
