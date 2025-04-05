import 'package:bitirme_projesi_app/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Text('LoginPage'),
            ElevatedButton(
              onPressed: () {},
              child: Text('Google ile Giriş Yapın'),
            )
          ],
        ),
      ),
    );
  }
}
