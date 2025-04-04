import 'package:bitirme_projesi_app/modules/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
