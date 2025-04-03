import 'package:bitirme_projesi_app/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class ApiConstants {
  static const baseurl = "";
}

class ApiService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  late Dio _dio;

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseurl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        contentType: "application/json"));

    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token= _storageService.getValue<String>(StorageKeys.UserToken);


        },
      onError: (response, handler) async{

      }

    ));
  }
}
