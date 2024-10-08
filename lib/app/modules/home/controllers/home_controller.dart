import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  final userName = 'User'.obs;
  final userEmail = 'user@example.com'.obs;


  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? 'user@example.com';
    final name = email.split('@').first;
    return {'name': name, 'email': email};
  }

  void loadUserInfo() async {
    final userInfo = await _getUserInfo();
    userName.value = userInfo['name'] ?? 'User';
    userEmail.value = userInfo['email'] ?? 'user@example.com';
  }
  @override
  void onInit() {
    loadUserInfo();
    super.onInit();
  }
}
