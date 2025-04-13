import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../about/about_page.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kişisel Bilgiler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoField('Ad Soyad', controller.name.value),
              const SizedBox(height: 8),
              _buildInfoField('E-posta', controller.email.value),
              const SizedBox(height: 8),
              _buildInfoField('Telefon', controller.phone.value),
              const SizedBox(height: 8),
              _buildInfoField('Adres', controller.address.value),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _showEditProfileDialog(context),
                child: const Text('Profili Düzenle'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: controller.name.value);
    final emailController = TextEditingController(text: controller.email.value);
    final phoneController = TextEditingController(text: controller.phone.value);
    final addressController =
        TextEditingController(text: controller.address.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Profili Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-posta'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Adres'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              controller.updateProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                address: addressController.text,
              );
              Get.back();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
