import 'package:bitirme_projesi_app/core/app_bindings.dart';
import 'package:bitirme_projesi_app/routers/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'B Ü T Ç E',
      getPages: AppPages.pages,
      initialRoute: AppRouters.HOME,
      initialBinding: AppBindings(),
    );
  }
}
