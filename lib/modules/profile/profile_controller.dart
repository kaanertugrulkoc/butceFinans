import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      // TODO: Profil bilgilerini yükle
      name.value = 'John Doe';
      email.value = 'john.doe@example.com';
      phone.value = '+90 555 555 55 55';
      address.value = 'İstanbul, Türkiye';
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Profil bilgileri yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      isLoading.value = true;
      // TODO: Profil bilgilerini güncelle
      this.name.value = name;
      this.email.value = email;
      this.phone.value = phone;
      this.address.value = address;
      Get.snackbar(
        'Başarılı',
        'Profil bilgileri güncellendi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Profil bilgileri güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
