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

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = _storageService.getValue<String>(StorageKeys.UserToken);
      if (token != null) {
        options.headers['authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }, onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        await _storageService.remove(StorageKeys.UserToken);
      }
      return handler.next(error);
    }));
    return this;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path,
          queryParameters: queryParameters, options: options);
    } catch (e) {
      print("Dio get error $e");
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      print("Dio post error $e");
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(path,
          queryParameters: queryParameters, options: options);
    } catch (e) {
      print("Dio put error $e");
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(path,
          queryParameters: queryParameters, options: options);
    } catch (e) {
      print("Dio delete error $e");
      rethrow;
    }
  }
}
