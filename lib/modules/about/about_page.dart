import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'about_controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FinansApp',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FinansApp, kişisel finans yönetiminizi kolaylaştırmak için tasarlanmış bir uygulamadır. Gelir ve giderlerinizi takip edebilir, kategorilere göre analiz yapabilir ve finansal hedeflerinize ulaşmak için planlama yapabilirsiniz.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Obx(() => Text(
                  'Versiyon: ${controller.version.value}',
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  'Son Güncelleme: ${controller.lastUpdate.value}',
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(height: 24),
            const Text(
              'İletişim',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  'Sorularınız ve önerileriniz için: ${controller.supportEmail.value}',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
