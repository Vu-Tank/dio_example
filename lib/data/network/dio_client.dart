import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_example/data/models/user_model.dart';
import 'package:dio_example/data/network/constant/end_points.dart';
import 'package:dio_example/shared_pre/shared_pre.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio()
          ..options.baseUrl = EndPoints.baseUrl
          ..options.connectTimeout = EndPoints.connectionTimeout
          ..options.receiveTimeout = EndPoints.receiveTimeout
          ..options.responseType = ResponseType.json {
    _dio
      ..interceptors.clear()
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          UserModel? userModel = await SharedPre.getUser();
          String? token = userModel?.token;
          options.headers['Content-Type'] = 'application/json';
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (e, handler) {},
        onError: (e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            try {
              UserModel? userModel = await SharedPre.getUser();
              String? token = userModel?.token;
              if (token != null && token.isNotEmpty) {
                final response = await _dio.post(
                  EndPoints.refreshToken,
                  data: jsonEncode({
                    'refreshToken': token,
                  }),
                );
                if (response.statusCode == 200) {
                  final UserModel userModel = UserModel.fromJson(response.data);
                  await SharedPre.saveUser(userModel);
                  e.requestOptions.headers["Authorization"] =
                      "Bearer ${userModel.token}";
                  //create request with new access token
                  final opts = Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers);
                  final cloneReq = await _dio.request(e.requestOptions.path,
                      options: opts,
                      data: e.requestOptions.data,
                      queryParameters: e.requestOptions.queryParameters);

                  return handler.resolve(cloneReq);
                } else {
                  await SharedPre.removeUser();
                  return handler.next(e.requestOptions as DioError);
                }
              } else {
                await SharedPre.removeUser();
                return handler.next(e.requestOptions as DioError);
              }
            } catch (e) {
              handler.reject(e as DioError);
            }
          }
        },
      ));
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
