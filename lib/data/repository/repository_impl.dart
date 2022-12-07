import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:userapp/data/model/user_model.dart';
import 'package:userapp/data/network_core.dart';
import 'package:userapp/data/repository/repository.dart';

class RepositoryImpl implements Repository {
  final network = Get.find<NetworkCore>();

  @override
  Future<List<UserModel>> getDataUser(
      int pageKey, String searchTerm, String query) async {
    try {
      Response response = await network.dio.get(
        '/users',
        queryParameters: {
          "page": pageKey,
          "per_page": 10,
          query: searchTerm,
        },
      );
      List<dynamic> listDataUser = response.data;
      List<UserModel> listData =
          listDataUser.map((data) => UserModel.fromJson(data)).toList();
      return listData;
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Response> deleteUser({required int userId}) async {
    network.dio.options.headers['Authorization'] =
        'Bearer 9c9cd97efe465ed19bcd5d4616895436855cfa03fc09b2109a0b7660970349c0';
    try {
      final response = await network.dio.delete(
        '/users/$userId',
      );
      return response;
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Response> postUser(
      {required String name,
      required String email,
      required String gender,
      required String status}) async {
    try {
      network.dio.options.headers['Authorization'] =
          'Bearer 9c9cd97efe465ed19bcd5d4616895436855cfa03fc09b2109a0b7660970349c0';
      final response = await network.dio.post(
        '/users',
        data: {
          'name': name,
          'email': email,
          'gender': gender,
          'status': status,
        },
      );
      return response;
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Email sudah ada');
      }
      throw Exception(e.message);
    }
  }

  @override
  Future<Response> updateUser({
    required int userId,
    required String name,
    required String email,
    required String gender,
    required String status,
  }) async {
    network.dio.options.headers['Authorization'] =
        'Bearer 9c9cd97efe465ed19bcd5d4616895436855cfa03fc09b2109a0b7660970349c0';
    try {
      final response = await network.dio.put(
        '/users/$userId',
        data: {
          'name': name,
          'email': email,
          'gender': gender,
          'status': status,
        },
      );
      return response;
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> getDetailUser(int id) async {
    try {
      final response = await network.dio.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
