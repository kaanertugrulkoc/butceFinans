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
  }
}
