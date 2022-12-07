import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:userapp/data/model/user_model.dart';
import 'package:userapp/screen/user/add/add_user_screen.dart';
import 'package:userapp/screen/user/detail/user_detail_screen.dart';
import 'package:userapp/screen/user/home/user_home_controller.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserHomeController>(
      init: UserHomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (search) => controller
                            .debouncer(() => controller.updateList(search)),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 32,
                            color: Colors.black,
                          ),
                          hintText: 'Cari User...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 50),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        controller.query = value;
                      },
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      itemBuilder: (BuildContext bc) {
                        return const [
                          PopupMenuItem(
                            value: 'id',
                            child: Text("ID"),
                          ),
                          PopupMenuItem(
                            value: 'name',
                            child: Text("Name"),
                          ),
                          PopupMenuItem(
                            value: 'email',
                            child: Text("Email"),
                          ),
                          PopupMenuItem(
                            value: 'status',
                            child: Text("Status"),
                          ),
                          PopupMenuItem(
                            value: 'gender',
                            child: Text("Gender"),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.pagingController.refresh(),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      PagedSliverList<int, UserModel?>(
                        pagingController: controller.pagingController,
                        builderDelegate: PagedChildBuilderDelegate<UserModel?>(
                          itemBuilder: (context, item, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const UserDetailScreen(),
                                    arguments: {
                                      'id': item.id,
                                    },
                                  )!
                                      .then((_) => controller.pagingController
                                          .refresh());
                                },
                                child: Card(
                                  elevation: 8,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item?.id.toString() ?? 'ID',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item!.name ?? 'Nama',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.email ?? 'Email',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.gender ?? 'Gender',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.status ?? 'Status',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(
                () => const AddUserScreen(),
              );
            },
            elevation: 8,
            child: const Icon(
              Icons.edit,
            ),
          ),
        );
      },
    );
  }
}
