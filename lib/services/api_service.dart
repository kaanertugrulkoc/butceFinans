

import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:get/get.dart';

class apiService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  late Dio _dio;


}