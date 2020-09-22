import 'package:dio/dio.dart';
import 'package:unord/data/constants.dart';

class NetworkHelper {
  NetworkHelper() {
    _dio = Dio(BaseOptions(
      baseUrl: URLs.host,
      connectTimeout: AppLimit.REQUEST_TIME_OUT,
      receiveTimeout: AppLimit.REQUEST_TIME_OUT,
      sendTimeout: AppLimit.REQUEST_TIME_OUT,
      headers: {
        // 'Authorization': 'Bearer ' +
        //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjAwNzAwMDA4LCJleHAiOjE2MDMyOTIwMDh9.nOpjJC_uPITttSp8kji_NTnoFvpiJzbIoJ-Rib0UJtQ',
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
    } catch (err) {
      rethrow;
    }
    return response;
  }
}
