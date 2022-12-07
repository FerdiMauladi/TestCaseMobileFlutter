import 'package:get/get.dart';
import 'package:userapp/data/network_core.dart';
import 'package:userapp/data/repository/repository.dart';
import 'package:userapp/data/repository/repository_impl.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkCore>(NetworkCore(), permanent: true);
    Get.put<Repository>(RepositoryImpl(), permanent: true);
  }
}