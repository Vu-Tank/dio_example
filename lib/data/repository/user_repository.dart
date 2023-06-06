import 'package:dio/dio.dart';
import 'package:dio_example/data/models/user_model.dart';
import 'package:dio_example/data/network/api/user_api.dart';

import '../network/dio_exception.dart';

class UserRepository {
  final UserApi userApi;
  UserRepository({required this.userApi});
  Future<UserModel> getUser() async {
    try {
      final response = await userApi.getUser();
      return UserModel.fromJson(response.data);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
