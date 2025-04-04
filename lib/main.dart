import 'package:bitirme_projesi_app/routers/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BÜTÇE',
      getPages: AppPages.pages,
      initialRoute: AppRouters.INITIAL,
    );
  }
}
