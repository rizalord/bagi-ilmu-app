import 'package:dio/dio.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/database_helper.dart';

class NetworkHelper extends DatabaseHelper {
  NetworkHelper() {
    String token = box.get('access_token', defaultValue: null);

    _dio = Dio(BaseOptions(
      baseUrl: URLs.host,
      connectTimeout: AppLimit.REQUEST_TIME_OUT,
      receiveTimeout: AppLimit.REQUEST_TIME_OUT,
      sendTimeout: AppLimit.REQUEST_TIME_OUT,
      headers: token == null
          ? {"Content-Type": "multipart/form-data"}
          : {
              'Authorization': 'Bearer ' + token,
              "Content-Type": "multipart/form-data"
            },
      validateStatus: (status) {
        return status < 500;
      },
    ));
  }

  Dio _dio;

  Future<dynamic> get(String url) async {
    dynamic response;
    try {
      response = await _dio.get<dynamic>(url);
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<dynamic> post(String url, dynamic data) async {
    dynamic response;
    try {
      response = await _dio.post<dynamic>(url, data: data);
    } on DioError catch (err) {
      if (err is DioError) {
      } else {}
    }
    return response;
  }

  Future<dynamic> put(String url, dynamic data) async {
    dynamic response;
    try {
      response = await _dio.put<dynamic>(url, data: data);
    } on DioError catch (err) {
      if (err is DioError) {
      } else {}
    }
    return response;
  }

  Future<dynamic> delete(String url) async {
    dynamic response;
    try {
      response = await _dio.delete<dynamic>(url);
    } catch (err) {
      rethrow;
    }
    return response;
  }
}
