import 'package:get/get.dart';

class BaseController extends GetxController {
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  void setLoading(bool value) => _isLoading.value = value;
}
