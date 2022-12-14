import 'package:dio/dio.dart';
import 'package:userapp/const/app_const.dart';

class NetworkCore {
  Dio dio = Dio();

  NetworkCore() {
    dio.options = BaseOptions(
        baseUrl: AppConst.baseUrl,
        connectTimeout: 20000,
        receiveTimeout: 20000,
        sendTimeout: 20000,
        headers: {
          'accept' : 'application/json',
        }
    );
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}