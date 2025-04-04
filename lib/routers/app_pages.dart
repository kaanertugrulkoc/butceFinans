import 'package:get/get.dart';

abstract class AppRouters{
  static const INITIAL =SPLASH;
  static const SPLASH ='/splash';
  static const LOGIN ='/login';
  static const HOME ='/home';
  static const PROFILE ='/profil';
}

class AppPages{
  static final pages =<GetPage>[
    GetPage(name: name, page: page)
  ];
}