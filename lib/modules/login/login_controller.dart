import 'package:bitirme_projesi_app/core/base_controller.dart';
import 'package:bitirme_projesi_app/services/auth_services.dart';

class LoginController extends BaseController{
late final AuthService _service;

@override
  void onInit() {

    super.onInit();
    _authservice = Get.find<AuthService>();
  }

  googleIleGirisYap()async{


  }

}