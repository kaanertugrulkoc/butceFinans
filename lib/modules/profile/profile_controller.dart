import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString username = 'Kullanıcı Adı'.obs;
  final RxString email = 'kullanici@email.com'.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkMode = false.obs;

  void updateProfile(String newUsername, String newEmail) {
    username.value = newUsername;
    email.value = newEmail;
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  void toggleDarkMode() {
    darkMode.value = !darkMode.value;
  }
}
