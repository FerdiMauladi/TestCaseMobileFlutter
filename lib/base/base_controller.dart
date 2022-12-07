import 'package:get/get.dart';
import 'package:userapp/data/repository/repository.dart';

abstract class BaseController extends GetxController {
  final repository = Get.find<Repository>();
}