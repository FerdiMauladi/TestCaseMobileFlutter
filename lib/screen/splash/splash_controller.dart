import 'dart:async';

import 'package:get/get.dart';
import 'package:userapp/base/base_controller.dart';
import 'package:userapp/screen/user/home/user_home_screen.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () async {
      Get.offAll(const UserHomeScreen());
    });
    super.onInit();
  }
}