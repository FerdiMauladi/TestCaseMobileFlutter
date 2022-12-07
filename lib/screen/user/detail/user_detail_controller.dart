import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/data/model/user_model.dart';
import 'package:userapp/screen/user/home/user_home_controller.dart';
import 'package:userapp/screen/user/home/user_home_screen.dart';

enum UserDetailViewState {
  none,
  loading,
  loadingStatus,
  error,
}

class UserDetailController extends UserHomeController {
  UserDetailViewState _state = UserDetailViewState.none;

  UserDetailViewState get stateDetail => _state;

  var id = Get.arguments;
  UserModel detailUser = UserModel();

  String? selectedGender;
  String? selectedStatus;
  bool isLoading = false;

  List<DropdownMenuItem<String>> get dropdownGender {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "male", child: Text("Male")),
      const DropdownMenuItem(value: "female", child: Text("Female")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownStatus {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "active", child: Text("Active")),
      const DropdownMenuItem(value: "inactive", child: Text("Inactive")),
    ];
    return menuItems;
  }

  final formKeyUpdate = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final statusController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  changeStateDetail(UserDetailViewState s) {
    _state = s;
    update();
  }

  @override
  void onInit() {
    getDetailUser();
    super.onInit();
  }

  Future getDetailUser() async {
    changeStateDetail(UserDetailViewState.loading);
    try {
      var data = await repository.getDetailUser(id['id']);
      detailUser = data;
      nameController.text = detailUser.name!;
      emailController.text = detailUser.email!;
      selectedGender = detailUser.gender;
      selectedStatus = detailUser.status;
      update();
      changeStateDetail(UserDetailViewState.none);
    } catch (e) {
      changeStateDetail(UserDetailViewState.error);
    }
  }

  Future updateUser() async {
    changeStateDetail(UserDetailViewState.loadingStatus);
    try {
      await repository
          .updateUser(
        userId: id['id'],
        name: nameController.text,
        email: emailController.text,
        gender: selectedGender!,
        status: selectedStatus!,
      )
          .then(
        (_) {
          changeStateDetail(UserDetailViewState.none);
          pagingController.refresh();
          Get.showSnackbar(
            const GetSnackBar(
              message: 'User berhasil di update',
              isDismissible: true,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          Get.offAll(() => const UserHomeScreen());
        },
      );
    } catch (e) {
      changeStateDetail(UserDetailViewState.none);
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Ada kesalahan saat ingin update user',
          isDismissible: true,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future deleteUser() async {
    changeStateDetail(UserDetailViewState.loadingStatus);
    try {
      await repository.deleteUser(userId: id['id']).then((_) {
        changeStateDetail(UserDetailViewState.none);
        pagingController.refresh();
        Get.showSnackbar(
          const GetSnackBar(
            message: 'User berhasil di hapus',
            isDismissible: true,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Get.offAll(() => const UserHomeScreen());
      });
    } catch (e) {
      changeStateDetail(UserDetailViewState.none);
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Ada kesalahan saat ingin menghapus user',
          isDismissible: true,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
