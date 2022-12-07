import 'package:dio/dio.dart';
import 'package:userapp/data/model/user_model.dart';

abstract class Repository {
  Future<List<UserModel>> getDataUser(int pageKey, String searchTerm, String query);
  Future<UserModel> getDetailUser(int id);

  Future<Response> postUser({
    required String name,
    required String email,
    required String gender,
    required String status,
  });

  Future<Response> updateUser({
    required int userId,
    required String name,
    required String email,
    required String gender,
    required String status,
  });

  Future<Response> deleteUser({
    required int userId,
  });
}
