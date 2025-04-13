import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routers/app_pages.dart';
import 'services/database_service.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Servisleri başlat
  final dbService = await Get.putAsync<DatabaseService>(() async {
    final service = DatabaseService();
    return service.init();
  });

  await Get.putAsync<StorageService>(() async => StorageService().init());
  await Get.putAsync<ApiService>(() async => ApiService().init());

  // Veritabanı yapısını kontrol et
  await dbService.checkDatabaseStructure();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FinansApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.pages,
    );
  }
}
