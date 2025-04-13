import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routers/app_pages.dart';
import 'services/database_service.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DatabaseService'i başlat ve kaydet
  final dbService = DatabaseService();
  await Get.putAsync<DatabaseService>(() async {
    await dbService.initialize();
    return dbService;
  });

  // Veritabanı yapısını kontrol et
  await dbService.verifyDatabaseStructure();

  // Diğer servisleri başlat
  await Get.putAsync<StorageService>(() async => StorageService().init());
  await Get.putAsync<ApiService>(() async => ApiService().init());

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
