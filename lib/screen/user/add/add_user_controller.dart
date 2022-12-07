import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/base/base_controller.dart';
import 'package:userapp/screen/user/home/user_home_controller.dart';
import 'package:userapp/screen/user/home/user_home_screen.dart';

enum AddUserViewState {
  none,
  loading,
  error,
}

class AddUserController extends UserHomeController {
  AddUserViewState _state = AddUserViewState.none;

  AddUserViewState get stateAdd => _state;
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

  final formKeyAdd = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  changeStateAdd(AddUserViewState s) {
    _state = s;
    update();
  }

  void postUser() async {
    changeStateAdd(AddUserViewState.loading);
    try {
      var response = await repository
          .postUser(
        name: nameController.text,
        email: emailController.text,
        status: selectedStatus!,
        gender: selectedGender!,
      )
          .then(
        (value) {
          pagingController.refresh();
          if (value.statusCode == 201) {
            Get.showSnackbar(
              const GetSnackBar(
                message: 'User berhasil di upload',
                isDismissible: true,
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );
            Get.offAll(() => const UserHomeScreen());
          }
        },
      );
    } catch (e) {
      changeStateAdd(AddUserViewState.none);
      if (e.toString().contains('Email sudah ada')) {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Email sudah digunakan',
            isDismissible: true,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Koneksi error atau data tidak valid',
            isDismissible: true,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
