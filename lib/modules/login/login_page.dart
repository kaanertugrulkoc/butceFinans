import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
