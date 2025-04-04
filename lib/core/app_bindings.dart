import 'package:bitirme_projesi_app/services/api_service.dart';
import 'package:bitirme_projesi_app/services/auth_services.dart';
import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    });
    await Get.putAsync<ApiService>(() async {
      final service = ApiService();
      await service.init();
      return service;
    });
    await Get.putAsync<AuthService>(() async {
      final service = AuthService();
      await service.init();
      return service;
    });
  }
}
