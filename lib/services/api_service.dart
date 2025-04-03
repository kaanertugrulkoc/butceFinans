

import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class ApiConstants{
  static const baseurl="";
}

class apiService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  late Dio _dio;

  Future<ApiService> init() async{
    _dio =Dio(BaseOptions(
      baseUrl:ApiConstants.baseurl,

    ));
  }


}