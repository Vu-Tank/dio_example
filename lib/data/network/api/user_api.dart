import 'package:dio/dio.dart';

import '../dio_client.dart';

class UserApi {
  final DioClient dioClient;
  UserApi({required this.dioClient});
  Future<Response> getUser() async {
    try {
      final Response response = await dioClient.get(
        '/users',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
